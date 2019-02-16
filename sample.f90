#if defined STRING
#  define dat c
#elif defined INT
#  define dat a
#endif
#define valtype real(4)

program main
  use treap_mod, only: treap, add, find, remove, show, get_size
  implicit none

  integer, parameter :: n = 10000
  type(treap) :: t
  integer :: i, a(n), seed(100)
  real(8) :: r
  character(20) :: c(n)
  valtype :: b

  seed(:) = 0
  call random_seed(put=seed)

  do i = 1, n
    call random_number(r)
    a(i) = floor(r * n)
    write(c(i), "(i10)") a(i)
  end do

  do i = 1, n
    call add(t, dat(i), float(dat(i)))
  end do

  print *, n, get_size(t)

  do i = 1, n
    b = find(t, dat(i))
    print *, b
  end do

  ! call show(t)

  do i = 1, n
    call remove(t, dat(i))
  end do

  call show(t)
end program main

