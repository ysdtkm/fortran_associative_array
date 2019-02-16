TARGET = a.out
FC = gfortran
DEBUG = yes
vpath %.f90 ../../

ifeq ($(DEBUG),yes)
  FFLAGS := -cpp -Wall -Wuninitialized -O0 -g3 -fbounds-check \
            -fbacktrace -fdump-core -ffpe-trap=invalid,zero,overflow -fimplicit-none \
            -finit-real=snan -finit-integer=-858993460
else
  FFLAGS := -cpp -Ofast -march=native -fbacktrace -fdump-core
endif
INCLUDES = -I../../

$(TARGET): add_erase_random.o treap_mod.o treap_struct.o
	$(FC) $(INCLUDES) $(FFLAGS) $^ -o $@

%.o: %.f90
	$(FC) $(INCLUDES) -c $(FFLAGS) $<

%.mod: %.o %.f90
	@:

add_erase_random.o: treap_mod.mod
treap_mod.o: treap_struct.mod

clean:
	rm -rf *.o *.cgh *.mod *.log $(TARGET) core.*

.PHONY: clean

