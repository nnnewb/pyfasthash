# Introduction 

![PyPI - Version](https://img.shields.io/pypi/v/pyhash2)
![PyPI - Downloads](https://img.shields.io/pypi/dw/pyhash2)
[![Continuous integration](https://github.com/nnnewb/pyfasthash/actions/workflows/ci.yml/badge.svg?event=push)](https://github.com/nnnewb/pyfasthash/actions/workflows/ci.yml)

> disclaimer: This project is a continuation of [pyfasthash](https://github.com/flier/pyfasthash), which is no longer actively maintained. 
> I forked it to resolve compatibility issues with newer Python versions.
> 
> pypy and Python 2.x support is dropped. Because I don't use them and I don't have time to fix it.
> MacOS support is also dropped for same reason.
> 
> Additionally, I've provided Windows AMD64 and Linux AMD64/AArch64 wheel packages for easier installation.

`pyhash` is a python non-cryptographic hash library.

It provides several common hash algorithms with C/C++ implementation for performance and compatibility.

```python
>>> import pyhash
>>> hasher = pyhash.fnv1_32()

>>> hasher('hello world')
2805756500L

>>> hasher('hello', ' ', 'world')
2805756500L

>>> hasher('world', seed=hasher('hello '))
2805756500L
```

It also can be used to generate fingerprints without seed.

```python
>>> import pyhash
>>> fp = pyhash.farm_fingerprint_64()

>>> fp('hello')
>>> 13009744463427800296L

>>> fp('hello', 'world')
>>> [13009744463427800296L, 16436542438370751598L]
```

**Notes**

`hasher('hello', ' ', 'world')` is a syntax sugar for `hasher('world', seed=hasher(' ', seed=hasher('hello')))`, and may not equals to `hasher('hello world')`, because some hash algorithms use different `hash` and `seed` size.

For example, `metro` hash always use 32bit seed for 64/128 bit hash value.

```python
>>> import pyhash
>>> hasher = pyhash.metro_64()

>>> hasher('hello world')
>>> 5622782129197849471L

>>> hasher('hello', ' ', 'world')
>>> 16402988188088019159L

>>> hasher('world', seed=hasher(' ', seed=hasher('hello')))
>>> 16402988188088019159L
```

# Installation

## Tested platforms

Following unit tests run by GitHub Action.

- Windows-latest + Python 3.7
- Windows-latest + Python 3.8
- Windows-latest + Python 3.9
- Windows-latest + Python 3.10
- Windows-latest + Python 3.11
- Windows-latest + Python 3.12
- Windows-latest + Python 3.13
- Linux (ubuntu-latest) + Python 3.7
- Linux (ubuntu-latest) + Python 3.8
- Linux (ubuntu-latest) + Python 3.9
- Linux (ubuntu-latest) + Python 3.10
- Linux (ubuntu-latest) + Python 3.11
- Linux (ubuntu-latest) + Python 3.12
- Linux (ubuntu-latest) + Python 3.13

And I manually build/run the unit tests on Linux (OpenEuler 24.03) + AArch64 (Kunpeng-920).

## Binary Wheel

simply run `pip install pyhash2`

## Source Distribution

You'll need C/C++ Compiler support c++14 and CMake >= 3.19.

Also Python development files are required. For example, on Ubuntu 20.04, you can install python3-dev with `apt install python3-dev`.

After all pre-requisites installed, you can install `pyhash` with pip

```bash
$ pip install pyhash2
```

**Notes**

If `pip` install failed with similar errors, [#27](https://github.com/flier/pyfasthash/issues/27)

```
/usr/lib/gcc/x86_64-linux-gnu/6/include/smmintrin.h:846:1: error: inlining failed in call to always_inline 'long long unsigned int _mm_crc32_u64(long long unsigned int, long long unsigned int)': target specific option mismatch
 _mm_crc32_u64 (unsigned long long __C, unsigned long long __V)
 ^~~~~~~~~~~~~
src/smhasher/metrohash64crc.cpp:52:34: note: called from here
             v[0] ^= _mm_crc32_u64(v[0], read_u64(ptr)); ptr += 8;
                     ~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~
```

Please upgrade `pip` and `setuptools` to latest version and try again

```bash
$ pip install --upgrade pip setuptools
```

**Notes**

If `pip` install failed on MacOS with similar errors [#28](https://github.com/flier/pyfasthash/issues/28)

```
   creating build/temp.macosx-10.6-intel-3.6
   ...
   /usr/bin/clang -fno-strict-aliasing -Wsign-compare -fno-common -dynamic -DNDEBUG -g -fwrapv -O3 -Wall -Wstrict-prototypes -arch i386 -arch x86_64 -g -c src/smhasher/metrohash64crc.cpp -o build/temp.macosx-10.6-intel-3.6/src/smhasher/metrohash64crc.o -msse4.2 -maes -mavx -mavx2
    src/smhasher/metrohash64crc.cpp:52:21: error: use of undeclared identifier '_mm_crc32_u64'
                v[0] ^= _mm_crc32_u64(v[0], read_u64(ptr)); ptr += 8;
                        ^
```

You may try to

```bash
$ CFLAGS="-mmacosx-version-min=10.13" pip install pyhash
```

# Algorithms

pyhash supports the following hash algorithms

- [FNV](http://isthe.com/chongo/tech/comp/fnv/) (Fowler-Noll-Vo) hash
  - fnv1_32
  - fnv1a_32
  - fnv1_64
  - fnv1a_64
- [MurmurHash](http://code.google.com/p/smhasher/)
  - murmur1_32
  - murmur1_aligned_32
  - murmur2_32
  - murmur2a_32
  - murmur2_aligned_32
  - murmur2_neutral_32
  - murmur2_x64_64a
  - murmur2_x86_64b
  - murmur3_32
  - murmur3_x86_128
  - murmur3_x64_128
- [lookup3](http://burtleburtle.net/bob/hash/doobs.html)
  - lookup3
  - lookup3_little
  - lookup3_big
- [SuperFastHash](http://www.azillionmonkeys.com/qed/hash.html)
  - super_fast_hash
- [City Hash](https://code.google.com/p/cityhash/)
  _ city_32
  - city_64
  - city_128
  - city_crc_128
  - city_fingerprint_256
- [Spooky Hash](http://burtleburtle.net/bob/hash/spooky.html)
  - spooky_32
  - spooky_64
  - spooky_128
- [FarmHash](https://github.com/google/farmhash)
  - farm_32
  - farm_64
  - farm_128
  - farm_fingerprint_32
  - farm_fingerprint_64
  - farm_fingerprint_128
- [MetroHash](https://github.com/jandrewrogers/MetroHash)
  - metro_64
  - metro_128
  - metro_crc_64
  - metro_crc_128
- [MumHash](https://github.com/vnmakarov/mum-hash)
  - mum_64
- [T1Ha](https://github.com/leo-yuriev/t1ha)
  - t1ha2 _(64-bit little-endian)_
  - t1ha2_128 _(128-bit little-endian)_
  - t1ha1 _(64-bit native-endian)_
  - t1ha1_le _(64-bit little-endian)_
  - t1ha1_be _(64-bit big-endian)_
  - t1ha0 _(64-bit, choice fastest function in runtime.)_
  - ~~t1_32~~
  - ~~t1_32_be~~
  - ~~t1_64~~
  - ~~t1_64_be~~
- [XXHash](https://github.com/Cyan4973/xxHash)
  - xx_32
  - xx_64
  - xxh3_64 **NEW**
  - xxh3_128 **NEW**
- [Highway Hash](https://github.com/google/highwayhash)
  - highway_64 **NEW**
  - highway_128 **NEW**
  - highway_256 **NEW**

## String and Bytes literals

Python has two types can be used to present string literals, the hash values of the two types are definitely different.

- For Python 3.x [String and Bytes literals](https://docs.python.org/3/reference/lexical_analysis.html#string-and-bytes-literals), `unicode` will be used by default, `bytes` can be used with the `b` prefix.

For example,

```
$ python3
Python 3.7.0 (default, Jun 29 2018, 20:13:13)
[Clang 9.1.0 (clang-902.0.39.2)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import pyhash
>>> hasher = pyhash.murmur3_32()
>>> hasher('foo')
2085578581
>>> hasher(u'foo')
2085578581
>>> hasher(b'foo')
4138058784
```

**NOTE:**

Some algorithms may result different values with different string types like `farm_64`.

```
$ python3
Python 3.11.9 (tags/v3.11.9:de54cf5, Apr  2 2024, 10:12:12) [MSC v.1938 64 bit (AMD64)] on win32
>>> import pyhash
>>> hasher = pyhash.farm_64()
>>> hasher('hello')
12843964867383994037
>>> hasher = pyhash.farm_64()
>>> hasher(b'hello')
13009744463427800296
```
