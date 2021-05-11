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
mkdir build
cd build
# loading intel paths to compile the model 
source $BASE_REPO/../config_intel.sh 
FLAGS="-xCORE-AVX2  -g -static-intel"; 
CFLAGS=$FLAGS CXXFLAGS=$FLAGS CC=mpiicc CXX=mpiicpc 
cmake .. -DCMAKE_INSTALL_PREFIX=$GROMACS_BINARY -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DGMX_MPI=on -DGMX_GPU=CUDA  -DGMX_FFT_LIBRARY=mkl -DGMX_OPENMP=ON -DGMX_SIMD=AVX2_256 -DGMX_CYCLE_SUBCOUNTERS=ON -DGMX_OPENMP_MAX_THREADS=32 -DBUILD_SHARED_LIBS=OFF  -DGMX_BUILD_HELP=OFF -DGMX_HWLOC=OFF 
make 
make check
make install 
