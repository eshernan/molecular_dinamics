#!/bin/bash
#For intel Xeon 
unset LD_LIBRARY_PATH
export BASE_COMPILER=/opt/intel/oneapi
source $BASE_COMPILER/mkl/latest/env/vars.sh intel64
source $BASE_COMPILER/inspector/latest/env/vars.sh intel64
source $BASE_COMPILER/vtune/latest/env/vars.sh intel64
source $BASE_COMPILER/advisor/latest/env/vars.sh intel64
source $BASE_COMPILER/compiler/latest/env/vars.sh intel64
source $BASE_COMPILER/mpi/latest/env/vars.sh intel64


ulimit -s unlimited