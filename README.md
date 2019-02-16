# Fortran associative array (a.k.a. hash table or dictionary)
[![Build Status](https://travis-ci.org/ysdtkm/fortran_associative_array.svg?branch=master)](https://travis-ci.org/ysdtkm/fortran_associative_array)
* Implemented with treap, a clever randomized binary search tree (technically, it's not a hash table)

## Specifications
* An associative array for fortran, which enables fast insertion, deletion, and search
    * Roughly corresponds to `std::set` and `std::map` of C++ standard template library (STL)
    * Operations already implemented
    
      |Operation                  |Cost     |Note                                          |
      |----                       |----     |----                                          |
      |Insertion                  |O(log n) |`add` subroutine                              |
      |Deletion                   |O(log n) |`remove` subroutine                           |
      |Search                     |O(log n) |`find` function                               |
      |Max/min/k-th element       |O(log n) |`get_kth_key` function                        |
      |Obtain size                |O(1)     |`get_size` function                           |

    * Other operations allowed by the data structure (not implemented)
    
      |Operation                  |Cost     |Note                                          |
      |----                       |----     |----                                          |
      |Assign                     |O(log n) |                                              |
      |Merge/split                |O(log n) |Destructive                                   |
      |(lower\|upper)\_bound      |O(log n) |                                              |
      |Range search               |>O(log n)|                                              |
      |Deep copy                  |O(n)     |Preorder DFS                                  |
      |Conversion to sorted array |O(n)     |`show` subroutine is similar                  |

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

