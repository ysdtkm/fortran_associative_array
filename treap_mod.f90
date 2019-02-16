#include <dtypes.h>
module treap_mod
  use treap_struct, only: node, my_count, insert, erase, exists, kth_node, delete_all, inorder
  implicit none
  private

  public :: treap, find, add, remove, show, get_size, get_kth_key

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

end module treap_mod
