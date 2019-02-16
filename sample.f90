#include <dtypes.h>
program main
  use dict_mod, only: dict, insert_or_assign, get_val, remove, show, get_size, exists
  implicit none

  integer, parameter :: n = 100
  type(dict) :: t
  integer :: i, m, a(n), seed(100)
  real(8) :: r
  valtype :: b
  keytype2, allocatable :: keys(:)
  valtype, allocatable :: vals(:)

  seed(:) = 0
  call random_seed(put=seed)

  do i = 1, n
    call random_number(r)
    a(i) = floor(r * n)
  end do

  do i = 1, n
    call insert_or_assign(t, a(i), float(a(i)))
  end do

  m = get_size(t)
  print *, m, "unique elements out of ", n
  allocate(keys(m), vals(m))
  call show(t, keys, vals, m)
  write (*, "(10i5)") keys
  deallocate(keys, vals)

  do i = 1, n
    b = get_val(t, a(i))
    if (abs(a(i) - b) > 0.0001) stop 3
  end do

  do i = 1, n
    if (exists(t, a(i))) then
      call remove(t, a(i))
    end if
  end do

end program main

