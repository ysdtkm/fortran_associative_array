program get_kth
  use treap_mod, only: treap, add, find, remove, show, get_size, get_kth_key
  implicit none

  integer, parameter :: n = 10000
  type(treap) :: t
  integer :: i
  real(4), parameter :: eps = 1e-6

  do i = 1, n
    call add(t, i, float(i))
  end do

  do i = 1, n
    if (abs(find(t, get_kth_key(t, i)) - i) > eps) stop 2
  end do
end program get_kth

