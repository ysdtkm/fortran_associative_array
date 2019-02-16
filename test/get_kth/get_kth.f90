! Only for integer
program get_kth
  use treap_mod, only: treap, add, find, remove, show, get_size, get_kth_key
  implicit none

  integer, parameter :: n = 10000
  type(treap) :: t
  integer :: i

  do i = 1, n
    call add(t, i)
  end do

  do i = 1, n
    if (get_kth_key(t, i) /= i) stop 2
  end do
end program get_kth

