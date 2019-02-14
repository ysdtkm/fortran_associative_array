# Fortran associative array (A.K.A. hash table or dictionary)
* Implemented with treap, a clever randomized binary search tree

## Purpose
* An associative array for fortran, which enables fast insertion, deletion, and search
    * Roughly corresponds to `std::set` and `std::map` of C++ standard template library (STL)

  |Operation|Cost|Note|
  |----|----|----|
  |Insertion|O(log n)| |
  |Deletion|O(log n)| |
  |Search|O(log n)| |
  |Max/min|O(log n)|Not implemented|
  |Merge/split|O(1)|Destructive; not implemented|
  |Obtain size|O(1)| |
  |Deep copy|O(n)|Not implemented|

## Usage
See `sample.f90` and `Makefile` for sample usage

## Todo
* Second argument (i.e., value of the dictionary)
    * Currently it is just implemented as a multiset rather than a dictionary
* Better key handling (insertion already exist, search not found, etc.)
* Ordered derived type as a key
    * https://software.intel.com/en-us/forums/intel-fortran-compiler-for-linux-and-mac-os-x/topic/595015

## References
* Treap https://en.wikipedia.org/wiki/Treap
* Treap https://www.slideshare.net/iwiwi/2-12188757

