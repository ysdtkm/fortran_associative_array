TARGET = a.out
DEBUG = yes
STD = c++17

CXX = g++
ifeq ($(DEBUG),yes)
  CXXFLAGS = -std=$(STD) -O0 -g3 -Wall -Wextra
else
  CXXFLAGS = -std=$(STD) -O2 -match=native
endif

$(TARGET): main.cc
	$(CXX) $(CXXFLAGS) $< -o $@

clean:
	rm -rf *.o *.mod *.log $(TARGET) core.*

.PHONY: clean debug

