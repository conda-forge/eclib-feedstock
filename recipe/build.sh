#!/bin/bash

export CFLAGS="-g -O3 $CFLAGS"
export CXXFLAGS="-g -O3 $CXXFLAGS"

chmod +x autogen.sh
./autogen.sh

chmod +x configure
./configure \
    --prefix="$PREFIX" \
    --with-ntl="$PREFIX" \
    --with-pari="$PREFIX" \
    --with-flint="$PREFIX" \
    --with-boost="no" \
    --disable-allprogs

make -j${CPU_COUNT}
make check
make install
