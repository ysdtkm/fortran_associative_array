#if defined STRING
#  define dat c
#elif defined INT
#  define dat a
#endif

program main
  use treap_mod, only: treap, add, find, remove, show, get_size
  implicit none
  integer :: i

  do i = 1, 1
    call test(10000)
  end do

  contains

  subroutine test(n)
    integer, intent(in) :: n
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

    print *, n, get_size(t)

    do i = 1, n
      b = find(t, dat(i))
      if (.not. b) stop 2
    end do

    ! call show(t)

    do i = 1, n
      call remove(t, dat(i))
    end do

    call show(t)
  end subroutine test
end program main

