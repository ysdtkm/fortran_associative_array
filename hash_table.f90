#define keytype integer(4)
#define valtype integer(4)

program hash_table  ! ttk module
  implicit none

  integer(4), parameter :: min_alloc = 64
  enum, bind(c)
    enumerator :: unused, used, deleted
  end enum

  type dictionary
    integer(4) :: num_elem = 0
    integer(4) :: num_del = 0
    integer(4) :: alloc_size = 0
    integer(4), allocatable :: flags(:)
    keytype, allocatable :: keys(:)
    valtype, allocatable :: vals(:)
  end type dictionary

  contains

  subroutine test()
    implicit none
    type(dictionary) :: di
    call insert_or_assign(di, 1, 1)
  end subroutine test

  subroutine insert_or_assign(di, key, val)
    implicit none
    type(dictionary), intent(inout) :: di
    keytype, intent(in) :: key
    valtype, intent(in) :: val
    if ((di%num_elem + di%num_del) * 2 >= di%alloc_size) then
      call rehash(di)
    end if

    ! allocate

  end subroutine insert_or_assign

  subroutine rehash(di)
    implicit none
    type(dictionary), intent(inout) :: di
    if (di%alloc_size == 0) then
      di%alloc_size = min_alloc
      allocate(di%flags(di%alloc_size))
      allocate(di%keys(di%alloc_size))
      allocate(di%vals(di%alloc_size))
    else
      di%alloc_size = di%alloc_size * 2
    end if
  end subroutine rehash

  ! exists
  ! get_val
  ! delete
  ! get_size
  ! get_keys_vals

end program hash_table
