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

source $BASE_REPO/download.sh 
tar -zxvf gromacs-2021.2.tar.gz
cd gromacs-*
if [ ! -d build ]; then 
    mkdir build
fi
cd build
export OpenMP_C_FLAGS="-liomp5"
export OpenMP_CXX_FLAGS="-liomp5"
export OpenMP_C_LIB_NAMES="iomp5"
export OpenMP_CXX_LIB_NAMES="iomp5"
export CMAKE_EXE_LINKER_FLAGS="-liomp5"
FLAGS="-xCORE-AVX2 -g -static-intel"; CFLAGS=$FLAGS; CXXFLAGS=$FLAGS; CC=mpiicc; CXX=mpiicpc  cmake .. -DCMAKE_CXX_COMPILER=dpcpp -DOpenMP_CXX_FLAGS="-qopenmp" -DOpenMP_CXX_LIB_NAMES="libiomp5" -DOpenMP_libiomp5_LIBRARY=/opt/intel/oneapi/compiler/latest/linux/compiler/lib/intel64_lin/libiomp5.so -DCMAKE_INSTALL_PREFIX=$GROMACS_BINARY -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DGMX_MPI=on -DGMX_GPU=CUDA -DGMX_CUDA_TARGET_SM="30;35;52;60;61;70;75"  -DGMX_OPENMP=ON -DGMX_SIMD=AVX2_256 -DGMX_CYCLE_SUBCOUNTERS=ON -DGMX_OPENMP_MAX_THREADS=32 -DBUILD_SHARED_LIBS=OFF  -DGMX_BUILD_HELP=OFF 
make 
make check
make install 