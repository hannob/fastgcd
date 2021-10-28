#!/bin/bash

__exists() {
    which $1 1>/dev/null 2>&1
}

get="fetch";
! __exists fetch && get="curl -OL";

GMP="gmp-6.2.1"
if [ ! -d $GMP ];
then

    if [ ! -f $GMP.tar.xz ];
    then
        $get https://gmplib.org/download/gmp/$GMP.tar.xz
    fi

    sum=`openssl sha256 $GMP.tar.xz | awk -F' ' '{print $2}'`

    if [[ $sum != "fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2" ]];
    then
        echo ''
        echo '=========================================='
        echo 'ERROR: could not verify gmp-6.2.1.tar.xz;'
        echo '=========================================='
        exit;
    fi

    tar xf $GMP.tar.xz
fi

cd $GMP
patch -p 1 < ../$GMP.patch
mkdir ../gmp-patched
./configure --prefix=$PWD/../gmp-patched/
make -j4
make install -j4
cd ..
make -j4

