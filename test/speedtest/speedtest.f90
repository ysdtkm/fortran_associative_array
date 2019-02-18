#define jmax 20
program speedtest
  use dict_mod, only: dict, insert_or_assign, get_val, remove, get_size, exists
  implicit none

  type linear_set
    integer :: cnt = 0
    integer :: keys(2 ** jmax)
    real(4) :: vals(2 ** jmax)

  end type linear_set

  type(dict) :: t
  type(linear_set) :: ls
  integer :: b, i, j, n, seed(100), t1, t2, t_rate
  integer, allocatable :: a(:)
  real(4) :: r

  do b = 0, 1
    do j = 5, jmax
      if (b == 0 .and. j > 17) cycle
      seed(:) = 0
      call random_seed(put=seed)
      n = 2 ** j
      allocate(a(n))

      do i = 1, n
        call random_number(r)
        a(i) = floor(r * n)
      end do

      call system_clock(t1)
      do i = 1, n
        if (b > 0) then
          call insert_or_assign(t, a(i), float(a(i)))
        else
          call linear_insert_or_assign(ls, a(i), float(a(i)))
        end if
      end do
      call system_clock(t2, t_rate)
      print *, n, (t2 - t1) / dble(t_rate) / dble(n)
      deallocate(a)
    end do
  end do

  contains

  subroutine linear_insert_or_assign(ls, key, val)
    implicit none
    type(linear_set), intent(inout) :: ls
    integer, intent(in) :: key
    real(4), intent(in) :: val

    if (linear_exists(ls, key)) return

    ls%cnt = ls%cnt + 1
    ls%keys(ls%cnt) = key
    ls%vals(ls%cnt) = val
  end subroutine linear_insert_or_assign

  function linear_exists(ls, key)
    implicit none
    type(linear_set), intent(in) :: ls
    integer, intent(in) :: key
    logical linear_exists
    integer :: i
    linear_exists = .false.
    do i = 1, ls%cnt
      if (ls%keys(i) == key) then
        linear_exists = .true.
        exit
      end if
    end do
  end function linear_exists
end program speedtest

