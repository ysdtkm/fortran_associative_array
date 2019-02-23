program test_hash_table
  use hash_table, only: dictionary, insert_or_assign
  implicit none
  call test()
  contains
  function time_hash_table(n)
    implicit none
    integer, intent(in) :: n
    integer :: i, t1, t2
    integer :: a(n)
    integer :: time_hash_table
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
    time_hash_table = t2 - t1
  end function time_hash_table

  subroutine test()
    implicit none
    integer, parameter :: jmax = 20
    integer :: j, seed(100), itr, itrmax, dt, dummy, t_rate, n

    seed(:) = 0
    call random_seed(put=seed)
    call system_clock(dummy, t_rate)

    do j = 1, jmax
      itrmax = 2 ** (jmax - j)
      dt = 0
      n = 2 ** j
      do itr = 1, itrmax
        dt = dt + time_hash_table(n)
      end do
      print *, n, dt / (dble(itrmax) * dble(t_rate) * n)
    end do
  end subroutine test

end program test_hash_table

