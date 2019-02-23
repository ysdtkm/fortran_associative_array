#define keytype integer(4)
#define valtype real(4)

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
    integer, parameter :: jmax = 20
    integer :: j, seed(100), itr, itrmax, dt, dummy, t_rate, n

    seed(:) = 0
    call random_seed(put=seed)
    call system_clock(dummy, t_rate)

    do j = 5, jmax
      itrmax = 2 ** (jmax - j)
      dt = 0
      n = 2 ** j
      do itr = 1, itrmax
        dt = dt + test_hash_table(n)
      end do
      print *, n, dt / (dble(itrmax) * dble(t_rate) * n)
    end do

  end subroutine test

  function test_hash_table(n)
    implicit none
    integer, intent(in) :: n
    integer :: i, t1, t2
    integer :: a(n)
    integer :: test_hash_table
    real(4) :: r
    type(dictionary) :: t
    do i = 1, n
      call random_number(r)
      a(i) = floor(r * n)
    end do

    call system_clock(t1)
    do i = 1, n
      call insert_or_assign(t, a(i), float(a(i)))
    end do
    call system_clock(t2)
    test_hash_table = t2 - t1
  end function test_hash_table

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

  pure function fnv_1a_32(s)
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
      call rehash(di, up=.true.)
    end if
    call pure_insert_or_assign(di, key, val)
  end subroutine insert_or_assign

  subroutine pure_insert_or_assign(di, key, val)
    ! Dictionary is assumed to have enough space
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
      else if (di%flags(addr) == used .and. di%keys(addr) == key) then
        di%vals(addr) = val
        overflow = .false.
        exit
      else
        addr = increment(di%alloc_size, addr)
      end if
    end do
    if (overflow) stop 1
  end subroutine pure_insert_or_assign

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

  subroutine rehash(di, up)
    implicit none
    type(dictionary), intent(inout) :: di
    logical, intent(in) :: up
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
      if (up) then
        call pure_alloc(di, 2 * n)
      else
        call pure_alloc(di, max(min_alloc, n / 4))
      end if
      do i = 1, n
        if (old_flags(i) == used) then
          call pure_insert_or_assign(di, old_keys(i), old_vals(i))
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

  function exists(di, key)
    implicit none
    type(dictionary), intent(in) :: di
    keytype, intent(in) :: key
    integer(4) :: addr, i
    logical :: exists
    exists = .false.
    addr = get_initial_addr(di%alloc_size, key)
    do i = 1, di%alloc_size
      if (di%flags(addr) == unused) then
        exit
      else if (di%flags(addr) == used .and. di%keys(addr) == key) then
        exists = .true.
        exit
      else
        addr = increment(di%alloc_size, addr)
      end if
    end do
  end function exists

  function get_val(di, key)
    implicit none
    type(dictionary), intent(in) :: di
    keytype, intent(in) :: key
    valtype :: get_val
    integer(4) :: addr, i
    addr = get_initial_addr(di%alloc_size, key)
    do i = 1, di%alloc_size
      if (di%flags(addr) == unused) then
        print *, "Error: query with nonexistent key"
        stop 3
      else if (di%flags(addr) == used .and. di%keys(addr) == key) then
        get_val = di%vals(addr)
        exit
      else
        addr = increment(di%alloc_size, addr)
      end if
    end do
  end function get_val

  subroutine delete(di, key)
    implicit none
    type(dictionary), intent(inout) :: di
    keytype, intent(in) :: key
    integer(4) :: addr, i
    addr = get_initial_addr(di%alloc_size, key)
    do i = 1, di%alloc_size
      if (di%flags(addr) == unused) then
        print *, "Error: nonexistent key cannot be deleted"
        stop 4
      else if (di%flags(addr) == used .and. di%keys(addr) == key) then
        di%flags(addr) = deleted
        di%num_del = di%num_del + 1
        di%num_elem = di%num_elem - 1
        if (di%num_elem * 16 < di%alloc_size .and. di%alloc_size > min_alloc) then
          call rehash(di, up=.false.)
        end if
        exit
      else
        addr = increment(di%alloc_size, addr)
      end if
    end do
  end subroutine delete

  pure function get_size(di)
    implicit none
    type(dictionary), intent(in) :: di
    integer :: get_size
    get_size = di%num_elem
  end function get_size

  subroutine get_keys_vals(di, keys, vals)
    implicit none
    type(dictionary), intent(in) :: di
    keytype, intent(out) :: keys(di%num_elem)
    valtype, intent(out) :: vals(di%num_elem)
    integer(4) :: cnt, i
    cnt = 0
    do i = 1, di%alloc_size
      if (di%flags(i) == used) then
        cnt = cnt + 1
        keys(cnt) = di%keys(i)
        vals(cnt) = di%vals(i)
      end if
    end do
    if (cnt /= di%num_elem) then
      print *, "Error: size mismatch"
      stop 5
    end if
  end subroutine get_keys_vals
end program hash_table