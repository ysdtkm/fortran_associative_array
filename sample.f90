#include <dtypes.h>
program sample
  use dict_mod, only: dict, exists, get_size, get_val, insert_or_assign, remove
  implicit none

  type(dict) :: ages

  call insert_or_assign(ages, "Alice", 28)
  call insert_or_assign(ages, "Bob", 13)
  call insert_or_assign(ages, "Carol", 47)

  print *, "Alice is ", get_val(ages, "Alice"), "years old"
  print *, "Is Dave included? ", exists(ages, "Dave")

  call remove(ages, "Bob")

  print *, "Now the dictionary has", get_size(ages), "records"
end program sample

