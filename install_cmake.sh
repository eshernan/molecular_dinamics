#/bin/bash 

yum install gcc-c++
wget --quiet --no-check-certificate https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2.tar.gz
tar -zxvf cmake-*
./bootstrap
make 
sudo make install 
