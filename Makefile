TARGET = a.out
FC = gfortran
DEBUG = yes

ifeq ($(DEBUG),yes)
  FFLAGS := -pg -cpp -Wall -Wuninitialized -O0 -g3 -fbounds-check \
            -fbacktrace -fdump-core -ffpe-trap=invalid,zero,overflow -fimplicit-none \
            -finit-real=snan -finit-integer=-858993460
else
  FFLAGS := -pg -cpp -Ofast -march=native -fbacktrace -fdump-core
endif
INCLUDE := -I.

exec: $(TARGET)
	./$<
	gprof $< | gprof2dot | dot -Tpdf > graph.pdf

$(TARGET): hash_table.o
	$(FC) $(MACROS) $(FFLAGS) $(INCLUDE) $^ -o $@

%.o: %.f90
	$(FC) $(MACROS) -c $(FFLAGS) $(INCLUDE) $<

%.mod: %.o %.f90
	@:

clean:
	rm -rf *.o *.mod *.gch *.log $(TARGET) core.*

.PHONY: clean

