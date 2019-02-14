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
MACROS = -DINT  # STRING or INT

$(TARGET): sample.o treap_mod.o
	$(FC) $(MACROS) $(FFLAGS) $^ -o $@

%.o: %.f90
	$(FC) $(MACROS) -c $(FFLAGS) $<

%.mod: %.o %.f90
	@:

sample.o: treap_mod.mod

clean:
	rm -rf *.o *.mod *.log $(TARGET) core.*

.PHONY: clean

