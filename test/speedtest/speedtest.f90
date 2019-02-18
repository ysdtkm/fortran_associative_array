#define jmax 20
#define ljmax 16
program speedtest
  use dict_mod, only: dict, insert_or_assign, get_val, remove, get_size, exists
  implicit none

  type linear_set
    integer :: cnt = 0
    integer :: keys(2 ** ljmax)
    real(4) :: vals(2 ** ljmax)
  end type linear_set

  integer :: b, j, seed(100), itr, dt, dummy, t_rate
  real(4) :: r

  seed(:) = 0
  call random_seed(put=seed)
  call system_clock(dummy, t_rate)

  do b = 0, 1
    do j = 5, jmax
      if (b == 0 .and. j > ljmax) cycle
      dt = 0
      if (b == 0) then
        do itr = 1, (2 ** (ljmax - j))
          dt = dt + test_linear(j)
        end do
      else
        do itr = 1, (2 ** (jmax - j))
          dt = dt + test_treap(j)
        end do
      end if
      print *, j, dt / (dble(itr) * dble(t_rate) * 2 ** j)
    end do
  end do

  contains

  function test_treap(j)
    implicit none
    integer, intent(in) :: j
    integer :: n, i, t1, t2
    integer :: a(2 ** j)
    integer :: test_treap
    type(dict) :: t
    n = 2 ** j
    do i = 1, n
      call random_number(r)
      a(i) = floor(r * n)
    end do

    call system_clock(t1)
    do i = 1, n
      call insert_or_assign(t, a(i), float(a(i)))
    end do
    call system_clock(t2)
    test_treap = t2 - t1
  end function test_treap

  function test_linear(j)
    implicit none
    integer, intent(in) :: j
    integer :: n, i, t1, t2
    integer :: a(2 ** j)
    type(linear_set) :: ls
    integer :: test_linear
    n = 2 ** j
    do i = 1, n
      call random_number(r)
      a(i) = floor(r * n)
    end do

    call system_clock(t1)
    do i = 1, n
      call linear_insert_or_assign(ls, a(i), float(a(i)))
    end do
    call system_clock(t2)
    test_linear = t2 - t1
  end function test_linear

  subroutine linear_insert_or_assign(ls, key, val)
    implicit none
    type(linear_set), intent(inout) :: ls
    integer, intent(in) :: key
    real(4), intent(in) :: val
    integer :: k

    k = linear_exists(ls, key)

    if (k > 0) then
      ls%vals(k) = val
    else
      ls%cnt = ls%cnt + 1
      ls%keys(ls%cnt) = key
      ls%vals(ls%cnt) = val
    end if
  end subroutine linear_insert_or_assign

  function linear_exists(ls, key)
    implicit none
    type(linear_set), intent(in) :: ls
    integer, intent(in) :: key
    integer ::  linear_exists
    integer :: i
    linear_exists = -1
    do i = 1, ls%cnt
      if (ls%keys(i) == key) then
        linear_exists = i
        exit
      end if
    end do
  end function linear_exists
end program speedtest

