#!/bin/pypy3
import sys
sys.path.append("/lib/python3.6/site-packages")
import io
import sympy

def gen_primes(name, cnt):
    sympy.sieve.extend(cnt)
    f = io.open(name, 'w')
    f.write("#include <vector>\n")
    f.write("std::vector<long long int> primes {")
    for n in range(1, sympy.sieve.search(cnt)[1]):
        f.write("{0}, ".format(sympy.sieve[n]))
    f.write("{0}".format(sympy.sieve[sympy.sieve.search(cnt)[1]]))
    f.write("};")
    f.close()
    return sympy.sieve[sympy.sieve.search(cnt)[1]]
