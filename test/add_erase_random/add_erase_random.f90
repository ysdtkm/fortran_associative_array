#if defined STRING
#  define dat c
#elif defined INT
#  define dat a
#endif

program add_erase_random
  use treap_mod, only: treap, add, find, remove, show, get_size
  implicit none

  integer, parameter :: n = 10000
  type(treap) :: t
  integer :: i, a(n), seed(100)
  real(8) :: r
  character(20) :: c(n)
  logical :: b

  seed(:) = 0
  call random_seed(put=seed)

  do i = 1, n
    call random_number(r)
    a(i) = floor(r * n)
    write(c(i), "(i10)") a(i)
  end do

  do i = 1, n
    call add(t, dat(i))
  end do

  if (get_size(t) /= n) stop 1

  do i = 1, n
    b = find(t, dat(i))
    if (.not. b) stop 2
  end do

  do i = 1, n
    call remove(t, dat(i))
  end do

  if (get_size(t) /= 0) stop 3
end program add_erase_random

