#include <dtypes.h>
program main
  use dict_mod, only: dict, insert_or_assign, get_val, remove, show, get_size, exists
  implicit none

  integer, parameter :: n = 10000
  type(dict) :: t
  integer :: i, a(n), seed(100)
  real(8) :: r
  valtype :: b

  seed(:) = 0
  call random_seed(put=seed)

  do i = 1, n
    call random_number(r)
    a(i) = floor(r * n)
  end do

  do i = 1, n
    call insert_or_assign(t, a(i), float(a(i)))
  end do

  print *, get_size(t), "unique elements out of ", n

  do i = 1, n
    b = get_val(t, a(i))
    if (abs(a(i) - b) > 0.0001) stop 3
  end do

  do i = 1, n
    if (exists(t, a(i))) then
      call remove(t, a(i))
    end if
  end do

  call show(t)
end program main

