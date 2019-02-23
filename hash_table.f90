#define keytype integer(4)
#define valtype integer(4)

program hash_table  ! ttk module
  implicit none

  integer(4), parameter :: min_alloc = 64
  integer(4), parameter :: fnv_offset_basis_32 = -2128831035  ! 0x811c9dc5
  integer(4), parameter :: fnv_prime_32 = 16777619
  enum, bind(c)
    enumerator :: unused, used, deleted
  end enum

  type dictionary
    integer(4) :: num_elem = 0
    integer(4) :: num_del = 0
    integer(4) :: alloc_size = 0  ! Power of 2 or 0
    integer(4), allocatable :: flags(:)
    keytype, allocatable :: keys(:)
    valtype, allocatable :: vals(:)
  end type dictionary

  call test()

  contains

  subroutine test()
    implicit none
    type(dictionary) :: di
    integer :: i
    do i = 1, 100
      call insert_or_assign(di, i, i)
    end do
    print *, di%flags
  end subroutine test

  pure function fnv_1a_32_int(x)
    implicit none
    integer(4), intent(in) :: x
    integer(4) :: fnv_1a_32_int, i
    integer(1) :: c(4)
    fnv_1a_32_int = fnv_offset_basis_32
    c = transfer(x, c)
    do i = 1, 4
      fnv_1a_32_int = fnv_prime_32 * ieor(fnv_1a_32_int, int(c(i), kind=4))
    end do
  end function fnv_1a_32_int

  function fnv_1a_32(s)
    implicit none
    character(*), intent(in) :: s
    integer(4) :: fnv_1a_32, i
    integer(1) :: c(len(s))
    fnv_1a_32 = fnv_offset_basis_32
    c = transfer(s, c, len(s))
    do i = 1, len(s)
      fnv_1a_32 = fnv_prime_32 * ieor(fnv_1a_32, int(c(i), kind=4))
    end do
  end function fnv_1a_32

  subroutine insert_or_assign(di, key, val)
    implicit none
    type(dictionary), intent(inout) :: di
    keytype, intent(in) :: key
    valtype, intent(in) :: val

    if ((di%num_elem + di%num_del) * 2 >= di%alloc_size) then
      call rehash(di)
    end if
    call pure_insert(di, key, val)
  end subroutine insert_or_assign

  subroutine pure_insert(di, key, val)
    ! Dictionary is assumed to have enough space
    ! ttk 重複処理
    implicit none
    type(dictionary), intent(inout) :: di
    keytype, intent(in) :: key
    valtype, intent(in) :: val
    integer(4) :: addr, i
    logical :: overflow
    addr = get_initial_addr(di%alloc_size, key)
    overflow = .true.
    do i = 1, di%alloc_size
      if (di%flags(addr) == unused) then
        di%flags(addr) = used
        di%keys(addr) = key
        di%vals(addr) = val
        di%num_elem = di%num_elem + 1
        overflow = .false.
        exit
      else
        addr = increment(di%alloc_size, addr)
      end if
    end do
    if (overflow) stop 1
  end subroutine pure_insert

  pure function get_initial_addr(n, key)
    implicit none
    keytype, intent(in) :: key
    integer(4), intent(in) :: n
    integer(4) :: get_initial_addr
    get_initial_addr = fnv_1a_32_int(key)
    get_initial_addr = iand(get_initial_addr, n - 1) + 1  ! 1-based
  end function get_initial_addr

  pure function increment(n, addr)
    implicit none
    integer(4), intent(in) :: n, addr
    integer(4) :: increment
    increment = iand(addr, n - 1) + 1  ! 1-based
  end function increment

  subroutine rehash(di)
    implicit none
    type(dictionary), intent(inout) :: di
    integer(4), allocatable :: old_flags(:)
    keytype, allocatable :: old_keys(:)
    valtype, allocatable :: old_vals(:)
    integer(4) :: i, n
    n = di%alloc_size
    if (n == 0) then
      call pure_alloc(di, min_alloc)
    else
      allocate(old_flags(n), old_keys(n), old_vals(n))
      old_flags = di%flags
      old_keys = di%keys
      old_vals = di%vals
      call pure_alloc(di, 2 * n)
      do i = 1, n
        if (old_flags(i) == used) then
          call pure_insert(di, old_keys(i), old_vals(i))
        end if
      end do
      deallocate(old_flags, old_keys, old_vals)
    end if
  end subroutine rehash

  subroutine pure_alloc(di, n)
    type(dictionary), intent(inout) :: di
    integer(4), intent(in) :: n
    if (di%alloc_size > 0) deallocate(di%flags, di%keys, di%vals)
    di%alloc_size = n
    allocate(di%flags(n), di%keys(n), di%vals(n))
    di%flags(:) = unused
    di%num_elem = 0
    di%num_del = 0
  end subroutine pure_alloc

  ! exists
  ! get_val
  ! delete
  ! get_size
  ! get_keys_vals

end program hash_table
