TARGET = a.out
FC = gfortran
DEBUG = yes

ifeq ($(DEBUG),yes)
  FFLAGS := -cpp -Wall -Wuninitialized -O0 -g3 -fbounds-check \
            -fbacktrace -fdump-core -ffpe-trap=invalid,zero,overflow -fimplicit-none \
            -finit-real=snan -finit-integer=-858993460
else
  FFLAGS := -cpp -Ofast -march=native -fbacktrace -fdump-core
endif
INCLUDE := -I.

$(TARGET): sample.o dict_mod.o treap_struct.o
	$(FC) $(MACROS) $(FFLAGS) $(INCLUDE) $^ -o $@

%.o: %.f90
	$(FC) $(MACROS) -c $(FFLAGS) $(INCLUDE) $<

%.mod: %.o %.f90
	@:

sample.o: dict_mod.mod
dict_mod.o: treap_struct.mod dtypes.h
treap_struct.o: dtypes.h

clean:
	rm -rf *.o *.mod *.gch *.log $(TARGET) core.*

.PHONY: clean

