#!/usr/bin/env bash
apt-get remove fio
cd ../Tools/Deb
dpkg -i fio_3.16-1_amd64.deb
fio -v
cd -