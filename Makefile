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

exec: $(TARGET)
	./$<
	gprof $< | gprof2dot -n 1 -e 1 | dot -Tpdf > graph.pdf

$(TARGET): test_hash_table.o hash_table.o
	$(FC) $(MACROS) $(FFLAGS) $(INCLUDE) $^ -o $@

%.o: %.f90
	$(FC) $(MACROS) -c $(FFLAGS) $(INCLUDE) $<

%.mod: %.o %.f90
	@:

test_hash_table.o: hash_table.mod

clean:
	rm -rf *.o *.mod *.gch *.log $(TARGET) core.*

.PHONY: clean

