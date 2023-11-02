#!/bin/bash

export CFLAGS="-g -O3 $CFLAGS"
export CXXFLAGS="-g -O3 $CXXFLAGS"

# eclib uses std::ptr_fun which was removed in C++17.
export CXXFLAGS="$CXXFLAGS -std=c++14"

# workaround for https://github.com/JohnCremona/eclib/issues/45
if [ "$(uname)" == "Linux" ]; then
    sed -i "s/long    rank(GEN x);//g" $PREFIX/include/pari/paridecl.h
fi

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
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check
fi
make install
