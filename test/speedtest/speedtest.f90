#define jmax 18
program speedtest
  use dict_mod, only: dict, insert_or_assign, get_val, remove, get_size, exists
  implicit none

  type linear_set
    integer :: cnt = 0
    integer :: keys(2 ** jmax)
    real(4) :: vals(2 ** jmax)
  end type linear_set

  integer :: b, j, seed(100), t1, t2, t_rate
  real(4) :: r

  seed(:) = 0
  call random_seed(put=seed)

  do b = 0, 1
    do j = 5, jmax
      if (b == 0 .and. j > 16) cycle
      if (b == 0) then
        call test_linear(j)
      else
        call test_treap(j)
      end if
    end do
  end do

  contains

  subroutine test_treap(j)
    implicit none
    integer, intent(in) :: j
    integer :: n, i
    integer :: a(2 ** j)
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
    call system_clock(t2, t_rate)

    print *, n, (t2 - t1) / dble(t_rate) / dble(n)
  end subroutine test_treap

  subroutine test_linear(j)
    implicit none
    integer, intent(in) :: j
    integer :: n, i
    integer :: a(2 ** j)
    type(linear_set) :: ls
    n = 2 ** j

    do i = 1, n
      call random_number(r)
      a(i) = floor(r * n)
    end do

    call system_clock(t1)
    do i = 1, n
      call linear_insert_or_assign(ls, a(i), float(a(i)))
    end do
    call system_clock(t2, t_rate)

    print *, n, (t2 - t1) / dble(t_rate) / dble(n)
  end subroutine test_linear

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

