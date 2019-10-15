##### 
# SET UP ENVIRONMENT
#
# Setup script for GCC
#
# Source whatever it is you need to set up your compiler here.
# Change this to use your compiler.
#source /dist/intel/parallel_studio_xe_2017/parallel_studio_xe_2017/psxevars.sh intel64

. /opt/apps/lmod/lmod/init/bash
module unload intel/*
module load intel/17.0.4
module load python3
module load cmake/3.10.2
module list

TOPDIR=`pwd`
INSTALLDIR=${TOPDIR}/install

# Source directory
SRCDIR=${TOPDIR}/../src

# Build directory
BUILDDIR=${TOPDIR}/build


### OpenMP
#OMPFLAGS="-fopenmp "
OMPFLAGS="-qopenmp "
OMPENABLE="--enable-openmp"

if test "X${MKLROOT}X" == "XX";
then
 MKL_INC=""
 MKL_LINK=""
else
 MKL_INC=" -I${MKLROOT}/include"
 if test "X${OMPFLAGS}X" == "XX";
 then
    MKL_LINK=" -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_lp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_sequential.a -Wl,--end-group -lpthread -lm"
 else
    # Threaded Libs
    MKL_LINK=" -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_lp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -lpthread -lm"
 fi
fi

echo "MKL INCLUDE FLAGS:" $MKL_INC
echo "MKL LINKL FLAGS:" $MKL_LINK

export PK_QPHIX_ISA="avx512"
export PK_KOKKOS_HOST_ARCH="KNL"
#ARCHFLAGS=" -march=knl "
ARCHFLAGS=" -xMIC-AVX512 "

#PK_CXXFLAGS=${OMPFLAGS}"-g -O3 -std=c++14 -stdlib=libc++ -Drestrict=__restrict__ "${ARCHFLAGS}
PK_CXXFLAGS=${OMPFLAGS}"-g -O3 -std=c++14 "${ARCHFLAGS}
PK_CFLAGS=${OMPFLAGS}"-g -O3 -std=c99 "${ARCHFLAGS}" "

### Make
PK_TARGET_JN="10"
MAKE="make -j ${PK_TARGET_JN}" 

# Compilers for compiling package (passed as CC to ./configure throghout) 
PK_CC="mpiicc"
PK_CXX="mpiicpc"
#PK_CC="mpicc"
#PK_CXX="mpicxx"

PK_HOST_CXX=icpc
#PK_HOST_CXX=clang++
#PK_HOST_CXXFLAGS="-g -O3 -std=c++11 -stdlib=libc++"
PK_HOST_CXXFLAGS="-g -O3 -std=c++11 "
#GNU Wrappers
#PK_CC=mpicc
#PK_CXX=mpicxx
#PK_CC="mpicc -cc=icc "
#PK_CXX="mpicxx -CC=icpc "
