#!/bin/sh
source ../setup-env.sh

if [ ! -d $BASE_PATH ]; then 
    mkdir $BASE_PATH
fi
if [ ! -d $GROMACS_INSTALLER ]; then 
    mkdir $GROMACS_INSTALLER
fi

if [ ! -d $INSTALLER_PATH ]; then 
    mkdir $INSTALLER_PATH
fi
source ../config_intel.sh
export BASE_REPO=$PWD
cd $GROMACS_INSTALLER
if [ ! -f $GROMACS_VERSION".tar.gz" ]; then 
    source $BASE_REPO/download.sh 
fi
if [ ! -d $GROMACS_VERSION ]; then 
    tar -zxvf $GROMACS_VERSION".tar.gz"
fi

cd gromacs-*
if [ -d build ]; then 
    rm -Rf  build
fi
mkdir  build
cd build

FLAGS="-xCORE-AVX2 -g -static-intel"; CFLAGS=$FLAGS; CXXFLAGS=$FLAGS; CC=mpiicc; CXX=mpiicpc  cmake .. -DCMAKE_CXX_COMPILER=mpiicpc -DOpenMP_CXX_FLAGS="-qopenmp" -DOpenMP_CXX_LIB_NAMES="libiomp5" -DOpenMP_libiomp5_LIBRARY=/opt/intel/oneapi/compiler/latest/linux/compiler/lib/intel64_lin/libiomp5.so -DCMAKE_INSTALL_PREFIX=$GROMACS_BINARY -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DGMX_MPI=on -DGMX_GPU=CUDA -DGMX_CUDA_TARGET_SM="70;75"  -DGMX_OPENMP=ON -DGMX_SIMD=AVX2_256 -DGMX_CYCLE_SUBCOUNTERS=ON -DGMX_OPENMP_MAX_THREADS=32 -DBUILD_SHARED_LIBS=OFF  -DGMX_BUILD_HELP=OFF 
make -j 8 
make check
make install 