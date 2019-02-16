#if defined STRING
#  define keytype1 character(:),allocatable
#  define keytype2 character(*)
#elif defined INT
#  define keytype1 integer(4)
#  define keytype2 integer(4)
#endif
#define valtype real(4)

module treap_mod
  implicit none
  private

  public :: treap, find, add, remove, show, get_size, get_kth_key

  type node
    ! Low level data structure and operations of treap
    type(node), pointer :: left => null(), right => null()
    keytype1 :: key
    valtype :: val
    integer :: pri  ! min-heap
    integer :: cnt = 1
  end type node

  type treap
    ! High level wrapper for randomized treap
    type(node), pointer :: root => null()
    integer :: randstate = 1231767121
    contains
    final :: destruct_treap
  end type treap

  contains

  pure function xorshift32(i)
    ! Todo: check if this implementation is correct also for signed integer
    implicit none
    integer(4), intent(in) :: i
    integer(4) :: xorshift32
    if (i == 0) then
      xorshift32 = 1231767121
    else
      xorshift32 = i
    end if
    xorshift32 = ieor(xorshift32, ishft(xorshift32, 13))
    xorshift32 = ieor(xorshift32, ishft(xorshift32, -17))
    xorshift32 = ieor(xorshift32, ishft(xorshift32, 15))
  end function xorshift32

  function find(t, key)
    implicit none
    type(treap), intent(in) :: t
    keytype2, intent(in) :: key
    type(node), pointer :: nd
    valtype :: find
    nd => exists(t%root, key)
    if (.not. associated(nd)) then
      stop 105
    end if
    find = nd%val
  end function find

  subroutine add(t, key, val)
    implicit none
    type(treap), intent(inout) :: t
    keytype2, intent(in) :: key
    valtype, intent(in) :: val
    t%root => insert(t%root, key, val, t%randstate)
    t%randstate = xorshift32(t%randstate)
  end subroutine add

  subroutine remove(t, key)
    implicit none
    type(treap), intent(inout) :: t
    keytype2, intent(in) :: key
    t%root => erase(t%root, key)
  end subroutine remove

  function get_kth_key(t, k)
    implicit none
    type(treap), intent(in) :: t
    integer, intent(in) :: k
    type(node), pointer :: res
    integer :: get_kth_key
    res => kth_node(t%root, k)
    if (associated(res)) then
      get_kth_key = res%key
    else
      print *, "get_kth_key failed"
      stop 2
    end if
  end function get_kth_key

  subroutine show(t)
    implicit none
    type(treap), intent(in) :: t
    call inorder(t%root)
  end subroutine show

  function get_size(t)
    implicit none
    type(treap), intent(in) :: t
    integer :: get_size
    get_size = my_count(t%root)
  end function get_size

  subroutine destruct_treap(t)
    implicit none
    type(treap), intent(inout) :: t
    call delete_all(t%root)
  end subroutine destruct_treap

  subroutine update(root)
    implicit none
    type(node), pointer, intent(in) :: root
    root%cnt = my_count(root%left) + my_count(root%right) + 1
  end subroutine update

  function my_count(root)
    implicit none
    type(node), pointer, intent(in) :: root
    integer :: my_count
    if (associated(root)) then
      my_count = root%cnt
    else
      my_count = 0
    end if
  end function my_count

  function rotate_ccw(root)
    implicit none
    type(node), pointer, intent(in) :: root
    type(node), pointer :: tmp, rotate_ccw
    if (.not. associated(root%right)) stop 1
    tmp => root%right
    root%right => tmp%left
    tmp%left => root
    rotate_ccw => tmp
    call update(root)
    call update(tmp)
  end function rotate_ccw

  function rotate_cw(root)
    implicit none
    type(node), pointer, intent(in) :: root
    type(node), pointer :: tmp, rotate_cw
    if (.not. associated(root%left)) stop 1
    tmp => root%left
    root%left => tmp%right
    tmp%right => root
    rotate_cw => tmp
    call update(root)
    call update(tmp)
  end function rotate_cw

  recursive function insert(root, key, val, pri) result(res)
    implicit none
    type(node), pointer, intent(in) :: root
    integer, intent(in) :: pri
    keytype2, intent(in) :: key
    valtype, intent(in) :: val
    type(node), pointer :: res

    if (.not. associated(root)) then
      allocate(res)
      res%key = key
      res%pri = pri
      res%val = val
    else
      res => root
      if (key > root%key) then
        root%right => insert(root%right, key, val, pri)
        call update(root)
        if (root%pri > root%right%pri) then
          res => rotate_ccw(res)
        end if
      else
        root%left => insert(root%left, key, val, pri)
        call update(root)
        if (root%pri > root%left%pri) then
          res => rotate_cw(res)
        end if
      end if
    end if
  end function insert

  recursive function erase(root, key) result(res)
    implicit none
    type(node), pointer, intent(in) :: root
    keytype2, intent(in) :: key
    type(node), pointer :: res, tmp

    if (.not. associated(root)) then
      print *, "Erase failed"
      stop 1
    end if

    if (key < root%key) then
      root%left => erase(root%left, key)
      res => root
    else if (key > root%key) then
      root%right => erase(root%right, key)
      res => root
    else
      if ((.not. associated(root%left)) .or. (.not. associated(root%right))) then
        tmp => root
        if (.not. associated(root%left)) then
          res => root%right
        else
          res => root%left
        end if
        deallocate(tmp)
      else
        if (root%left%pri < root%right%pri) then
          res => rotate_ccw(root)
          res%left => erase(res%left, key)
        else
          res => rotate_cw(root)
          res%right => erase(res%right, key)
        end if
      end if
    end if
    if (associated(res)) call update(res)
  end function erase

  recursive function exists(root, key) result(res)
    implicit none
    type(node), pointer, intent(in) :: root
    keytype2, intent(in) :: key
    type(node), pointer :: res
    if (.not. associated(root)) then
      res => null()
    else if (root%key == key) then
      res => root
    else if (key < root%key) then
      res => exists(root%left, key)
    else
      res => exists(root%right, key)
    end if
  end function exists

  recursive function kth_node(root, k) result(res)
    implicit none
    type(node), pointer, intent(in) :: root
    integer, intent(in) :: k
    type(node), pointer :: res
    if (.not. associated(root)) then
      res => null()
    else if (k <= my_count(root%left)) then
      res => kth_node(root%left, k)
    else if (k == my_count(root%left) + 1) then
      res => root
    else
      res => kth_node(root%right, k - my_count(root%left) - 1)
    end if
  end function kth_node

  recursive subroutine delete_all(root)
    implicit none
    type(node), pointer, intent(inout) :: root
    if (.not. associated(root)) return

    call delete_all(root%left)
    call delete_all(root%right)
    deallocate(root)
    nullify(root)
  end subroutine delete_all

  recursive subroutine inorder(root)
    implicit none
    type(node), pointer, intent(in) :: root
    if (.not. associated(root)) return

    call inorder(root%left)
    print *, "key:", root%key, "val:", root%val, ", pri:", root%pri, ", size:", root%cnt
    call inorder(root%right)
  end subroutine inorder

end module treap_mod
