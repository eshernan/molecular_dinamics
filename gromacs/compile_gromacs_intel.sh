#!/bin/sh
source ../setup-env.sh

if [ ! -d "$BASE_PATH" ]; then 
    mkdir $BASE_PATH
fi
if [ ! -d "$GROMACS_PATH" ]; then 
    mkdir GROMACS_PATH
fi

if [ ! -d "$INSTALLER_PATH" ]; then 
    mkdir $INSTALLER_PATH
fi
cd $INSTALLER_PATH
source download.sh 
tar -zxvf gromacs-2021.2.tar.gz
cd gromacs-*
mkdir build
cd build
FLAGS="-xCORE-AVX2 " and -DGMX_SIMD=AVX2_256
cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DGMX_MPI=on -DGMX_GPU=on -DGMX_FFT_LIBRARY=mkl -DGMX_SIMD=AVX2_256
make 
make check
sudo make install 
