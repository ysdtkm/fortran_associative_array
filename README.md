# Fortran associative array (a.k.a. hash table or dictionary)
* Implemented with treap, a clever randomized binary search tree (technically, it's not a hash table)

## Specifications
* An associative array for fortran, which enables fast insertion, deletion, and search
    * Roughly corresponds to `std::set` and `std::map` of C++ standard template library (STL)
    * Operations allowed by the data structure
    
      |Operation|Cost|Note|
      |----|----|----|
      |Insertion|O(log n)| |
      |Deletion|O(log n)| |
      |Search|O(log n)| |
      |Max/min/k-th element|O(log n)|Not implemented|
      |Merge/split|O(log n)|Not implemented; destructive|
      |Obtain size|O(1)| |
      |Deep copy|O(n)|Not implemented; preorder DFS|
      |Conversion to sorted array|O(n)|Not implemented; inorder DFS|

* Has its own random state; does not change Fortran's intrinsic random state or affect other objects

## Usage
* See `sample.f90` and `Makefile` for sample usage
* Edit `dtypes.h` for using for another data types
    * For arbitrary length string key, `keytype1` should be `character(:),allocatable` and `keytype2` should be `character(*)`
    * For other key types, `keytype1` and `keytype2` are the same

## Todo
* Second argument (i.e., value of the dictionary)
    * Currently it is just implemented as a multiset rather than a dictionary
* Better key handling (insertion already exist, search not found, etc.)
* Ordered derived type as a key
    * https://software.intel.com/en-us/forums/intel-fortran-compiler-for-linux-and-mac-os-x/topic/595015
* `exists` should return pointer to the node found

## Tested with
* https://arc033.contest.atcoder.jp/submissions/4270463
* Valgrind for memory leak

## References
* Treap https://en.wikipedia.org/wiki/Treap
* Treap https://www.slideshare.net/iwiwi/2-12188757

