#include <dtypes.h>
program add_erase_random
  use treap_mod, only: treap, add, find, remove, show, get_size, key_exists
  implicit none

  integer, parameter :: n = 10000
  type(treap) :: t
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
    call add(t, a(i), float(a(i)))
  end do

  do i = 1, n
    b = find(t, a(i))
    if (abs(b - a(i)) > 0.0001) stop 2
  end do

  do i = 1, n
    if (key_exists(t, a(i))) then
      call remove(t, a(i))
    end if
  end do

  if (get_size(t) /= 0) stop 4

  do i = 1, n
    call add(t, a(i), float(a(i)))
  end do
end program add_erase_random

