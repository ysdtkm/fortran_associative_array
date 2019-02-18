#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np

def get_linear():
    res = '''512   1.9531250000000000E-006
        1024   9.7656250000000002E-007
        2048   2.4414062500000001E-006
        4096   4.6386718749999999E-006
        8192   9.2773437499999998E-006
       16384   1.8737792968750000E-005
       32768   3.6865234374999999E-005
       65536   7.1472167968750002E-005
      131072   1.4350891113281249E-004'''
    return res

def get_treap():
    res = '''4096   4.8828125000000001E-007
        8192   3.6621093750000001E-007
       16384   4.8828125000000001E-007
       32768   6.4086914062500004E-007
       65536   7.3242187500000002E-007
      131072   9.3078613281249998E-007
      262144   1.0566711425781251E-006
      524288   1.4362335205078125E-006
     1048576   1.6250610351562500E-006'''
    return res

def get_map():
    res = '''32 9e-07
        64 5.54688e-07
        128 9.16406e-07
        256 6.55078e-07
        512 6.68555e-07
        1024 7.10449e-07
        2048 5.65771e-07
        4096 6.13403e-07
        8192 6.95032e-07
        16384 7.32031e-07
        32768 8.33487e-07
        65536 8.88303e-07
        131072 9.56544e-07
        262144 1.06414e-06
        524288 1.26099e-06
        1048576 1.37791e-06'''
    return res

def lines_to_array(ls):
    res = []
    for l in ls.split("\n"):
        n, t = l.split()
        res.append([float(n), float(t)])
    return np.array(res).T

def main():
    lin = lines_to_array(get_linear())
    tre = lines_to_array(get_treap())
    map = lines_to_array(get_map())

    plt.rcParams["font.size"] = 16
    fig, ax = plt.subplots(tight_layout=True)
    ax.loglog(lin[0], lin[1], label="Linear array")
    ax.loglog(tre[0], tre[1], label="This module")
    ax.loglog(map[0], map[1], label="std::map")
    ax.legend()
    ax.set_title("Cost of insert_or_assign")
    ax.set_xlabel("Number of elements")
    ax.set_ylabel("Time per element [sec]")
    fig.savefig("out.png")
    plt.close(fig)

if __name__ == "__main__":
    main()
