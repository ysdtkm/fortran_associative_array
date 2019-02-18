program speedtest
  use dict_mod, only: dict, insert_or_assign, get_val, remove, get_size, exists
  implicit none

  type(dict) :: t
  integer :: i, j, n, seed(100), t1, t2, t_rate
  integer, allocatable :: a(:)
  real(8) :: r

  do j = 5, 20
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
      call insert_or_assign(t, a(i), float(a(i)))
    end do
    call system_clock(t2, t_rate)
    print *, n, (t2 - t1) / dble(t_rate) / dble(n)
    deallocate(a)
  end do
end program speedtest

