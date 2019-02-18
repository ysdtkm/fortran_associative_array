#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np

def get_linear():
    res = '''32   6.1035156250000001E-008
          64   9.1552734375000002E-008
         128   1.3732910156249999E-007
         256   2.8991699218749999E-007
         512   4.2724609375000001E-007
        1024   8.8500976562500004E-007
        2048   1.5563964843749999E-006
        4096   2.9907226562500001E-006
        8192   6.0729980468750003E-006
       16384   1.2283325195312501E-005
       32768   2.4154663085937499E-005
       65536   4.8141479492187497E-005'''
    return res



def get_treap():
    res = '''32   1.5640258789062501E-007
          64   1.9550323486328124E-007
         128   2.2888183593749999E-007
         256   2.6035308837890627E-007
         512   2.8705596923828124E-007
        1024   3.1471252441406251E-007
        2048   3.3760070800781248E-007
        4096   3.7860870361328127E-007
        8192   4.2533874511718751E-007
       16384   5.0258636474609377E-007
       32768   5.9700012207031250E-007
       65536   6.9332122802734373E-007
      131072   7.5817108154296879E-007
      262144   9.6321105957031251E-007
      524288   1.2388229370117187E-006
     1048576   1.5335083007812501E-006'''
    return res

def get_map():
    res = '''32 3.76313e-07
        64 4.38184e-07
        128 4.21282e-07
        256 4.59784e-07
        512 4.8752e-07
        1024 5.29837e-07
        2048 5.59647e-07
        4096 5.90503e-07
        8192 6.25697e-07
        16384 6.86414e-07
        32768 7.49547e-07
        65536 8.56623e-07
        131072 1.07595e-06
        262144 1.16947e-06
        524288 1.30604e-06
        1048576 1.44749e-06'''
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
