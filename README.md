# MiniQhull

[![Build Status](https://travis-ci.com/gridap/MiniQhull.jl.svg?branch=master)](https://travis-ci.com/gridap/MiniQhull.jl)
[![Codecov](https://codecov.io/gh/gridap/MiniQhull.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/gridap/MiniQhull.jl)

[MiniQhull](https://github.com/gridap/MiniQhull.jl) ([Qhull](http://www.qhull.org/)-based Delaunay triangulation).

## Documentation

`MiniQhull` julia package provides a single function: `delaunay`.

There are two available interfaces for `MiniQhull.delaunay` functions:

### Coordinates vector

```julia
delaunay(dim::Integer, numpoints::Integer, points::Vector) -> Matrix{Int32}
```
vector length must agree with `dim*numpoints` and points must be in "component major order", i.e., components are consequitive within the vector. The resulting matrix has shape `(dim+1,nsimplices)`, where `nsimplices` is the number of
simplices in the computed delaunay triangulation.

### Coordinates matrix

```julia
delaunay(points::Matrix) -> Matrix{Int32}
```
with `size(matrix) == (dim,numpoints)`.


## Usage

Delaunay function accepts both vector and matrix data type to define input coordinates.

Coordinates vector size must agree with `dim*numpoints`.
```julia
    dim          = 2
    numpoints    = 4
    coordinates  = [0,0,0,1,1,0,1,1]
    connectivity = delaunay(dim, numpoints, coordinates)
```

Coordinates matrix must be in row mayor order (C style).
```julia
    coordinates  = [0 0 1 1; 0 1 0 1]
    connectivity = delaunay(coordinates)
```

## Installation

**MiniQhull** itself is installed when you add and use it into another project.

Please, ensure that your system fulfill the requirements.

To include into your project form Julia REPL, use the following commands:

```
pkg> add MiniQhull
julia> using MiniQhull
```

If, for any reason, you need to manually build the project (e.g., you added the project with the wrong environment resulting a build that fails, you have fixed the environment and want to re-build the project), write down the following commands in Julia REPL:
```
pkg> add MiniQhull
pkg> build MiniQhull
julia> using MiniQhull
```

### Requirements

`MiniQhull` julia package requires [Qhull](http://www.qhull.org/) reentrant library installed in a system path. Reentrant `Qhull` library can be installed in any path on your local machine. In order to succesfull describe your custom installation to be located by `MiniQhull`, you must export `QHULL_ROOT_DIR` environment variable. If this environment variables are not available, `MiniQhull` will try to find the library in the usual linux user library directory (`/usr/lib`).

`MiniQhull` also requires any C compiler installed on the system.

#### Qhull installation

##### From Sources

Custom installation of `Qhull` can be performed as described in the official [Qhull installation instructions](http://www.qhull.org/README.txt). 
You can find the latest source code in the oficial [Qhull download section](http://www.qhull.org/download/).

##### Debian-based installation from package manager

Reentrant `Qhull` can be obtained from the default repositories of your Debian-based OS by means of `apt` tool.

Basic reentrant `Qhull` installation in order to use it from `MiniQhull` julia package is as follows:

```
$ sudo apt-get install update
$ sudo apt-get install libqhull-r7 libqhull-dev
```

If you need to install a C compiler, it can be also obtained by means of `apt` tool:
```
$ sudo apt-get update
$ sudo apt-get gcc
```

## Continuous integration

In order to take advantage of `MiniQhull` julia package during continuous integration, you must ensure that the requirements are fullfilled in the CI environment.

If your CI process is based on `Travis-CI` you can add the following block at the beginning of your `.travis.yml` file:

```
addons:
  apt:
    update: true
    packages:
    - gcc
    - libqhull-r7
    - libqhull-dev
```

