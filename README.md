# Fortran associative array (a.k.a. hash table or dictionary)
[![Build Status](https://travis-ci.org/ysdtkm/fortran_associative_array.svg?branch=master)](https://travis-ci.org/ysdtkm/fortran_associative_array)
* Implemented with treap, a clever randomized binary search tree (technically, it's not a hash table)

## Specifications
* An associative array for fortran, which enables fast insertion, deletion, and search
    * Roughly corresponds to `std::set` and `std::map` of C++ standard template library (STL)
    * Operations allowed by the data structure
    
      |Operation|Cost|Note|
      |----|----|----|
      |Insertion `std::map.insert`|O(log n)|`add` subroutine|
      |Deletion `std::map.erase`|O(log n)|`remove` subroutine|
      |Search|O(log n)|`find` function|
      |Assign `std::map.assign`|O(log n)|Not implemented|
      |Max/min/k-th element|O(log n)|`get_kth_key` function|
      |Merge/split|O(log n)|Not implemented; destructive|
      |Obtain size|O(1)|`get_size` function|
      |(lower|upper)\_bound|O(log n)|Not implemented|
      |Deep copy|O(n)|Not implemented; preorder DFS|
      |Conversion to sorted array|O(n)|Not implemented; `show` subroutine is similar|

* Has its own random state; does not change Fortran's intrinsic random state or affect other objects

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

