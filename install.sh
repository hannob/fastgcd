#!/bin/bash

__exists() {
    which $1 1>/dev/null 2>&1
}

get="fetch";
! __exists fetch && get="curl -OL";

if [ ! -d gmp-6.1.2 ];
then

    if [ ! -f gmp-6.1.2.tar.bz2 ];
    then
        $get https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2
    fi

    sum=`openssl sha256 gmp-6.1.2.tar.bz2 | awk -F' ' '{print $2}'`

    if [[ $sum != "5275bb04f4863a13516b2f39392ac5e272f5e1bb8057b18aec1c9b79d73d8fb2" ]];
    then
        echo ''
        echo '=========================================='
        echo 'ERROR: could not verify gmp-6.1.2.tar.bz2;'
        echo 'Downloaded over untrusted channel (non-https)'
        echo '=========================================='
        exit;
    fi

    tar xf gmp-6.1.2.tar.bz2
fi

cd gmp-6.1.2
patch -p 1 < ../gmp-6.1.2.patch
mkdir ../gmp-patched
./configure --prefix=$PWD/../gmp-patched/
make
make install
cd ..
make

