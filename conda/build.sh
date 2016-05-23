#!/bin/bash

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  if [ $ARCH -eq 64 ]; then
    VL_ARCH="glnxa64"
  else
    VL_ARCH="glnx86"
  fi
  DYNAMIC_EXT="so"
  DISABLE_OPENMP=0
fi
if [ "$(uname -s)" == "Darwin" ]; then
  VL_ARCH="maci64"
  DYNAMIC_EXT="dylib"
  # OpenMP isn't supported on clang at this time
  DISABLE_OPENMP=1
fi

# Turn off all optimisations. Use vlfeat_avx for a fast version
make NO_TESTS=yes ARCH=${VL_ARCH} DISABLE_AVX=yes DISABLE_OPENMP=$DISABLE_OPENMP MKOCTFILE="" MEX="" VERB=1 -j${CPU_COUNT}

# Copy all the files and executables
mkdir -p $PREFIX/bin
cp bin/${VL_ARCH}/sift $PREFIX/bin/sift
cp bin/${VL_ARCH}/mser $PREFIX/bin/mser
cp bin/${VL_ARCH}/aib $PREFIX/bin/aib

mkdir -p $PREFIX/lib
cp bin/${VL_ARCH}/libvl.${DYNAMIC_EXT} $PREFIX/lib/libvl.${DYNAMIC_EXT}
mkdir -p $PREFIX/include/vl
cp vl/*.h $PREFIX/include/vl/

# For some reason the instal_name_tool fails, so I do it manually here
if [ "$(uname -s)" == "Darwin" ]; then
  install_name_tool -id @rpath/libvl.dylib $PREFIX/lib/libvl.dylib
  install_name_tool -change @loader_path/libvl.dylib @rpath/../lib/libvl.dylib $PREFIX/bin/sift
  install_name_tool -change @loader_path/libvl.dylib @rpath/../lib/libvl.dylib $PREFIX/bin/mser
  install_name_tool -change @loader_path/libvl.dylib @rpath/../lib/libvl.dylib $PREFIX/bin/aib
fi
