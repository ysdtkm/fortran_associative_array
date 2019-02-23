#define keytype integer(4)
#define valtype integer(4)

module hash_table
  implicit none

  type dictionary
    integer(4) :: num_elem = 0
    integer(4) :: num_del = 0
    integer(4) :: alloc_size = 0
    integer(4), allocatable :: flags
    keytype, allocatable :: keys
    valtype, allocatable :: vals
  end type dictionary

  contains

  ! exists
  ! get_val
  ! insert_or_assign
  ! delete
  ! get_size
  ! get_keys_vals

end module hash_table
