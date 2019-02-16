program sample
  use dict_mod, only: dict, exists, get_size, get_val, insert_or_assign, remove
  implicit none

  type(dict) :: ages  ! Initialized empty

  call insert_or_assign(ages, "Alice", 28)
  call insert_or_assign(ages, "Bob",   13)
  call insert_or_assign(ages, "Carol", 47)
  call insert_or_assign(ages, "Alice", 35)  ! Updated

  print *, "Alice is", get_val(ages, "Alice"), "years old"  ! 35
  print *, "Do we know Dave's age?", exists(ages, "Dave")   ! False

  call remove(ages, "Bob")

  print *, "Now we know the ages of", get_size(ages), "people"  ! Alice and Carol
end program sample

