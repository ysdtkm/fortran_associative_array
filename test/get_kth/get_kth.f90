program get_kth
  use dict_mod, only: dict, insert_or_assign, get_val, get_kth_key
  implicit none

  integer, parameter :: n = 10000
  type(dict) :: t
  integer :: i
  real(4), parameter :: eps = 1e-6

  do i = 1, n
    call insert_or_assign(t, i, float(i))
  end do

  do i = 1, n
    if (abs(get_val(t, get_kth_key(t, i)) - i) > eps) stop 2
  end do
end program get_kth

