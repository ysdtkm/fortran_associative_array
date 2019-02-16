#include <dtypes.h>
module dict_mod
  ! High level wrapper of dictionary data structure

  use treap_struct, only: node, my_count, insert, erase, find_node, kth_node, delete_all, inorder
  implicit none

  private
  public :: dict, get_val, insert_or_assign, exists, remove, get_keys_vals, get_size, get_kth_key

  type dict
    type(node), pointer :: root => null()
    integer :: randstate = 1231767121
    contains
    final :: destruct_dict
  end type dict

  contains

  pure function xorshift32(i)
    ! Todo: check if this implementation is correct also for signed integer
    implicit none
    integer(4), intent(in) :: i
    integer(4) :: xorshift32
    if (i == 0) then
      xorshift32 = 1231767121
    else
      xorshift32 = i
    end if
    xorshift32 = ieor(xorshift32, ishft(xorshift32, 13))
    xorshift32 = ieor(xorshift32, ishft(xorshift32, -17))
    xorshift32 = ieor(xorshift32, ishft(xorshift32, 15))
  end function xorshift32

  function get_val(t, key)
    implicit none
    type(dict), intent(in) :: t
    keytype2, intent(in) :: key
    type(node), pointer :: nd
    valtype :: get_val
    nd => find_node(t%root, key)
    if (.not. associated(nd)) then
      stop 105
    end if
    get_val = nd%val
  end function get_val

  function exists(t, key)
    implicit none
    type(dict), intent(in) :: t
    keytype2, intent(in) :: key
    type(node), pointer :: nd
    logical :: exists
    nd => find_node(t%root, key)
    exists = (associated(nd))
  end function exists

  subroutine insert_or_assign(t, key, val)
    implicit none
    type(dict), intent(inout) :: t
    keytype2, intent(in) :: key
    valtype, intent(in) :: val
    type(node), pointer :: nd
    nd => find_node(t%root, key)
    if (associated(nd)) then
      nd%val = val
    else  ! This implementation is not optimal
      t%root => insert(t%root, key, val, t%randstate)
      t%randstate = xorshift32(t%randstate)
    end if
  end subroutine insert_or_assign

  subroutine remove(t, key)
    implicit none
    type(dict), intent(inout) :: t
    keytype2, intent(in) :: key
    t%root => erase(t%root, key)
  end subroutine remove

  function get_kth_key(t, k)
    implicit none
    type(dict), intent(in) :: t
    integer, intent(in) :: k
    type(node), pointer :: res
    integer :: get_kth_key
    res => kth_node(t%root, k)
    if (associated(res)) then
      get_kth_key = res%key
    else
      print *, "get_kth_key failed"
      stop 2
    end if
  end function get_kth_key

  subroutine get_keys_vals(t, keys, vals, n)
    implicit none
    type(dict), intent(in) :: t
    integer, intent(in) :: n
    integer :: counter
    keytype2 :: keys(n)
    valtype :: vals(n)
    if (my_count(t%root) /= n) stop 5
    counter = 0
    call inorder(t%root, keys, vals, counter)
  end subroutine get_keys_vals

  function get_size(t)
    implicit none
    type(dict), intent(in) :: t
    integer :: get_size
    get_size = my_count(t%root)
  end function get_size

  subroutine destruct_dict(t)
    implicit none
    type(dict), intent(inout) :: t
    call delete_all(t%root)
  end subroutine destruct_dict

end module dict_mod
