# pear

This repository contains wip/experimental programming language.

# Building

## lemon

```sh
cd external/lemon
make
```

## re2c

```
cd external/re2c
autoreconf -i -W all
mkdir build
cd build
../configure
make
```

## pear

```
mkdir build
cd build
cmake ..
make
```
