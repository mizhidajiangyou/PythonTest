#!/usr/bin/env bash
echo y |apt-get install apache2
echo y |apt-get install python3
echo y |apt-get install python3-pip
echo y |apt-get install fio
echo y |apt-get install mysql-server
echo y |apt-get install smartmountools
echo y |apt-get install vim
echo y |apt-get install multipath-tools
echo y |apt-get install default-jdk
echo y |apt-get install default-jre
echo y |apt-get install sysstat
echo y |apt-get install open-iscsi
echo y |apt-get install nfs-common
echo y |apt-get install git

echo "defaults {
user_friendly_names	yes
max_fds	max
flush_on_last_del	yes
queue_without_daemon	no
dev_loss_tmo	180
prio	alua
path_checker	tur
path_grouping_policy	group_by_prio
failback	immediate
no_path_retry	300
path_selector	"round-robin 0"
rr_weight	uniform
rr_min_io	128
}
devices {
device {
vendor	"pppp"
product	"zzz"
hardware_handler	"1 alua"
retain_attached_hw_handler	yes
detect_prio	yes
fast_io_fail_tmo	60
}
}"  >>  /etc/multipath.conf
/etc/init.d/multipath-tools restart


pip install matplotlib
pip install pytest
pip install allure-pytest
pip install Selenium
pip install pytest-shutil
pip install pymongo
pip install pymysql
pip install Django



kvm(){
grep -Eoc '(vmx|svm)' /proc/cpuinfo
echo y |apt install cpu-checker
echo y |apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager
sudo systemctl start libvirtd.service
sudo systemctl is-active libvirtd
#sudo usermod -aG libvirt $USER
#sudo usermod -aG KVM $USER
}