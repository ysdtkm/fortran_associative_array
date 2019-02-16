# Fortran associative array (a.k.a. hash table or dictionary)
[![Build Status](https://travis-ci.org/ysdtkm/fortran_associative_array.svg?branch=master)](https://travis-ci.org/ysdtkm/fortran_associative_array)
* Implemented with treap, a clever randomized binary search tree (technically, it's not a hash table)

## Specifications
* An associative array for fortran, which enables fast insertion, deletion, and search
    * Roughly corresponds to `std::map` of C++ standard template library (STL) or `dict` type of Python
    * Operations already implemented
    
      |Operation                  |Cost     |Note                                          |
      |----                       |----     |----                                          |
      |Insertion/assignment       |O(log n) |`insert_or_assign` subroutine                 |
      |Deletion                   |O(log n) |`remove` subroutine                           |
      |Existence/lookup           |O(log n) |`exists` and `get_val` functions              |
      |Max/min/k-th element       |O(log n) |`get_kth_key` function                        |
      |Count                      |O(1)     |`get_size` function                           |

    * Other operations allowed by the data structure (not implemented)
    
      |Operation                  |Cost                     |Note                                          |
      |----                       |----                     |----                                          |
      |Merge/split                |O(log n)                 |Destructive                                   |
      |(lower\|upper)\_bound      |O(log n)                 |                                              |
      |Range search               |O(log n + elements found)|                                              |
      |Deep copy                  |O(n)                     |Preorder DFS                                  |
      |Conversion to sorted array |O(n)                     |`show` subroutine is similar                  |

* Has its own random state; does not change Fortran's intrinsic random state or affect other objects

## Usage
* See `sample.f90` and `Makefile` for sample usage
* Edit `dtypes.h` for using for another data types
    * For arbitrary length string key, `keytype1` should be `character(:),allocatable` and `keytype2` should be `character(*)`
    * For other key types, `keytype1` and `keytype2` are the same

## Todo
* Ordered derived type as a key
    * https://software.intel.com/en-us/forums/intel-fortran-compiler-for-linux-and-mac-os-x/topic/595015

## References
* Treap https://en.wikipedia.org/wiki/Treap
* Treap https://www.slideshare.net/iwiwi/2-12188757

