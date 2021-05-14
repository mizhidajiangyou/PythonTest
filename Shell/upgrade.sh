#!/usr/bin/env bash
#$1=20210506 $2="fix bug" $3="5.2.1.BETA3.0506"
cd $1
cp ../x86-p/* ./
sed -i "s/0.0.0000/${3}/g" pkg.lsm
sed -i "s/description_for_this_up/$2/g" pkg.lsm
cd ../
sed -i "s/9.9.9999/${3}/g" pkg.lsm-origin
sed -i "s/description_for_this_up/$2/g" pkg.lsm-origin
pkgname="dubheflash_${3}_x86.pkg"
echo ${pkgname: -4}
makeself.sh --gzip --nox11 --follow --lsm pkg.lsm-origin $1/ ${pkgname} \"${pkgname: -4}"_1"\" echo "extract success"
num=`python ussfed-pkg.py ${pkgname}`
echo ${num}
sed -i "s/00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000/${num}/g" ${pkgname}
sh ${pkgname} --check
rm pkg.lsm-origin
cp pkg-bak pkg.lsm-origin
