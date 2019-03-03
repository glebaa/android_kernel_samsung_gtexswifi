#!/bin/bash

export kernel=Samsung
export outdir=/home/gleba1337/work/out
export makeopts="-j$(nproc)"
export device_defconfig="gtexswifi-dt_defconfig"
export zImagePath="build/arch/arm/boot/zImage"
export KBUILD_BUILD_USER=gleba1337
export KBUILD_BUILD_HOST=lubuntu
export CROSS_COMPILE=/home/gleba1337/compiler/arm-eabi-4.8/bin/arm-eabi-
export ARCH=arm
export shouldclean="0"
export device="gtexswifi"

export version=$(cat version)
export RDIR=$(pwd)


function build() {
    if [[ $shouldclean =~ "1" ]] ; then
        rm -rf build
    fi

    mkdir -p build

    make -C ${RDIR} O=build ${makeopts} ${device_defconfig}
    make -C ${RDIR} O=build ${makeopts}
    make -C ${RDIR}/build O=build ${makeopts} modules
    make -C ${RDIR}/build O=build ${makeopts} dtbs

    zip/dtbTool -p build/scripts/dtc/ -o zip/dtb build/arch/arm/boot/dts/

    make -C external_module/wifi O=build KDIR=${RDIR}/build
    make -C external_module/mali O=build MALI_PLATFORM=sc8830 BUILD=release KDIR=${RDIR}/build
    
    if [ -a ${zImagePath} ] ; then
        cp ${zImagePath} zip/zImage
        mkdir -p zip/modules
        find -name '*.ko' -exec cp -av {} zip//modules/ \;
        cd zip
        zip -q -r ${kernel}-${device}-${version}.zip anykernel.sh  META-INF tools zImage dtb dhtb.pad modules
    else
        echo -e "\n\e[31m***** Build Failed *****\e[0m\n"
    fi

    if ! [ -d ${outdir} ] ; then
        mkdir ${outdir}
    fi

    if [ -a ${kernel}-${device}-${version}.zip ] ; then
        mv -v ${kernel}-${device}-${version}.zip ${outdir}
    fi

    cd ${RDIR}

    rm -f zip/zImage
    rm -rf zip/modules/*
    rm -f zip/dtb
}

if [[ $1 =~ "clean" ]] ; then
    shouldclean="1"
fi

build
