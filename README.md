# Fortran associative array [![Build Status](https://travis-ci.org/ysdtkm/fortran_associative_array.svg?branch=master)](https://travis-ci.org/ysdtkm/fortran_associative_array)
A scalable associative array (known as **hash table** or **dictionary** data types) for Fortran

## Specifications
* Internal data structure is treap (randomized binary search tree)
* Roughly corresponds to `std::map` (C++) or `dict` (Python)
    * A **key** can be `characters` (either fixed or arbitrary length), an `integer`, or a `real`
    * A **value** can be any fortran intrinsic data type. A **copy** of the value is stored in the `dict` object
* Implemented operations

  |Operation                  |Cost     |Note                                          |
  |----                       |----     |----                                          |
  |Insertion/assignment       |O(log n) |`insert_or_assign` subroutine                 |
  |Deletion                   |O(log n) |`remove` subroutine; error if not exist       |
  |Existence of a key         |O(log n) |`exists` function                             |
  |Reference                  |O(log n) |`get_val` function; error if not exist        |
  |Max/min/k-th element       |O(log n) |`get_kth_key` function; error if not exist    |
  |Count                      |O(1)     |`get_size` function                           |
  |Retrieve sorted array      |O(n)     |`get_keys_vals` subroutine                    |
  |Clear                      |O(n)     |Implicitly called as a destructor             |

* Other operations allowed by the data structure (not implemented)

  |Operation                  |Cost                     |Note                                          |
  |----                       |----                     |----                                          |
  |Merge/split                |O(log n)                 |Destructive                                   |
  |lower_bound/upper_bound    |O(log n)                 |                                              |
  |Range search               |O(log n + elements found)|                                              |
  |Deep copy                  |O(n)                     |Preorder DFS                                  |

## Usage
* See `sample.f90` for sample usage
* Edit `dtypes.h` for using for another data types
    * For string key (arbitrary length), `keytype1` should be `character(:),allocatable` and `keytype2` should be `character(*)`
    * For other key types, `keytype1` and `keytype2` are the same

## References
* Treap https://en.wikipedia.org/wiki/Treap
* Treap https://www.slideshare.net/iwiwi/2-12188757

