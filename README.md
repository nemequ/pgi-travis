# Obsolete

This repository is obsolete. NVIDIA (who now owns PGI) now offers
packages which integrate with various package managers (including
apt, which can be used on Travis) and straightforward installation
instructions.

For details, see https://developer.nvidia.com/hpc-sdk-downloads

# Install PGI Community Edition on Travis CI

[![Build Status](https://travis-ci.org/nemequ/pgi-travis.svg?branch=master)](https://travis-ci.org/nemequ/pgi-travis)

This project is intended to provide an easy way to use [PGI Community
Edition](http://www.pgroup.com/products/community.htm) on Travis.

## Usage

It is currently possible to use this script with either version of
Ubuntu which Travis currently supports (12.04 or 14.04), with or
without sudo.

You'll need to run the `install-pgi.sh` script.  There are two main
ways to go about that: you can copy the `install-pgi.sh` script to
your repository, or download the latest version from GitHub every time
you want to run it.

The main advantage of placing a copy of `install-pgi.sh` in your repo
is stability; you know the script is not going to change in a way that
breaks backwards compatibility.  On the other hand, stability can also
be a disadvantage; you will not be able to take advantage of bug fixes
and new versions automatically.

Downloading a copy of the script every time you run it is less stable,
but it means you always get the latest version.

We prefer that you download a copy every time; this allows us to
better fix any issues, and makes it easier for us to comply with any
requests from PGI.

If you do choose to have Travis download a copy every time, you can
use this command:

```bash
curl -s \
  'https://raw.githubusercontent.com/nemequ/pgi-travis/master/install-pgi.sh' | \
  /bin/sh
```

Most of the time you'll want to add a PGI build to a matrix, not just
switch to PGI.  In this case, you can do something like:

```yaml
matrix:
  include:
    - env: C_COMPILER=pgcc CXX_COMPILER=pgc++

before_install:
- if [ "${C_COMPILER}" = "pgcc" -o "${CXX_COMPILER}" = "pgc++" ]; then curl -s 'https://raw.githubusercontent.com/nemequ/pgi-travis/master/install-pgi.sh' | /bin/sh; fi

###
## If we use the matrix to set CC/CXX Travis overwrites the values,
## so instead we use C/CXX_COMPILER then copy the values to CC/CXX
## here (after Travis has set CC/CXX).
###
- if [ -n "${C_COMPILER}" ]; then export CC="${C_COMPILER}"; fi
- if [ -n "${CXX_COMPILER}" ]; then export CXX="${CXX_COMPILER}"; fi
```

This can easily be extended to test multiple versions of GCC/clang in
addition to PGI.  For an example, see
[hedley](https://github.com/nemequ/hedley/blob/master/.travis.yml).

#### Arguments

Currently, there are several arguments you can pass:

 - `--dest DIR`: Location to install to.  Default: ${HOME}/pgi
 - `--tmpdir DIR`: Location for temporary files.  Default: /tmp
 - `--nvidia`: Install Nvidia tools.
 - `--amd`: Install AMD tools.
 - `--java`: Install Java tools.
 - `--mpi`: Install MPI tools.
 - `--mpi-gpu`: Install MPI GPU support.
 - `--managed`: Install managed tools.
 - `--verbose`: Be a bit more verbose.

Use a space to separate argument names from values (*i.e.*, `--dest
/opt/foo` **not** `--dest=/opt/foo`.

## Legal Information

By installing PGI with this script you agree to the [PGI End-User
License Agreement](http://www.pgroup.com/doc/LICENSE.txt).

PGI graciously provides PGI Community Edition for free.  Please make
sure your usage complies with their terms, and do not abuse it.
Basically, don't do anything to screw this up for the rest of us.

To the extent possible under law, the author(s) of this script (not
PGI Community Edition) have waived all copyright and related or
neighboring rights to this work.  For details, see the [CC0 1.0
Universal Public Domain
Dedication](https://creativecommons.org/publicdomain/zero/1.0/) for
details.
