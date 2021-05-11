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
export BASE_REPO=$PWD
cd $GROMACS_INSTALLER
source $BASE_REPO/download.sh 
tar -zxvf gromacs-2021.2.tar.gz
cd gromacs-*
if [ ! -d build ]; then 
    mkdir build
fi
cd build
FLAGS="-xCORE-AVX2"; CFLAGS=$FLAGS; CXXFLAGS=$FLAGS; CC=mpicc; CXX=mpicpc  cmake .. -DCMAKE_INSTALL_PREFIX=$GROMACS_BINARY -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DGMX_MPI=on -DGMX_GPU=CUDA -DGMX_CUDA_TARGET_SM="30;35;52;60;61;70;75"  -DGMX_OPENMP=ON -DGMX_SIMD=AVX2_256 -DGMX_CYCLE_SUBCOUNTERS=ON -DGMX_OPENMP_MAX_THREADS=32 -DBUILD_SHARED_LIBS=OFF  -DGMX_BUILD_HELP=OFF 
make 
make check
make install 