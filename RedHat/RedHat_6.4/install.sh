#!/bin/bash

# change official yum source to 163
rpm -qa | grep yum | xargs rpm -e --nodeps
wget http://mirrors.163.com/centos/6/os/x86_64/Packages/python-iniparse-0.3.1-2.1.el6.noarch.rpm
wget http://mirrors.163.com/centos/6/os/x86_64/Packages/yum-metadata-parser-1.1.2-16.el6.x86_64.rpm
wget http://mirrors.163.com/centos/6/os/x86_64/Packages/yum-3.2.29-81.el6.centos.noarch.rpm
wget http://mirrors.163.com/centos/6/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.30-40.el6.noarch.rpm
rpm -ivh python-iniparse-0.3.1-2.1.el6.noarch.rpm
rpm -ivh yum-metadata-parser-1.1.2-16.el6.x86_64.rpm
rpm -e --nodeps python-urlgrabber-3.9.1-8.el6.noarch
wget http://mirrors.163.com/centos/6/os/x86_64/Packages/python-urlgrabber-3.9.1-11.el6.noarch.rpm
rpm -ivh yum-3.2.29-81.el6.centos.noarch.rpm yum-plugin-fastestmirror-1.1.30-40.el6.noarch.rpm python-urlgrabber-3.9.1-11.el6.noarch.rpm
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
mv CentOS6-Base-163.repo /etc/yum.repos.d/
sed -i 's/\$releasever/6/g'  /etc/yum.repos.d/CentOS6-Base-163.repo
yum clean all
yum makecache
rm *.rpm

yum -y update python
yum -y install openssh-server
chkconfig sshd on
systemctl enable sshd.service
# conflicts with file from package redhat-rpm-config-9.1.0-68.el7.centos.noarch
#yum -y install http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
# yum -y install cloud-init

echo "NOZEROCONF=yes" >> /etc/sysconfig/network

chkconfig iptables off

yum -y install glibc gcc gcc-c++ libs libtool gthread zlib
#yum -y install glib2 glib2-devel zlibrary zlib-devel
#yum -y install gthread libtool automake
#yum -y install bison flex
yum -y install qemu-guest-agent
#echo "EXEC cd /tmp && wget http://download.qemu-project.org/qemu-2.3.1.tar.xz"
#cd /tmp && wget --timeout=120 http://download.qemu-project.org/qemu-2.3.1.tar.xz
#echo "EXEC cd /tmp && tar -xf qemu-2.3.1.tar.xz"
#cd /tmp && tar -xf qemu-2.3.1.tar.xz
#echo "EXEC cd /tmp/qemu-2.3.1 && ./configure && make qemu_ga"
#cd /tmp/qemu-2.3.1 && ./configure && make qemu-ga
#echo "EXEC cd /tmp/qemu-2.3.1 && make install"
#cd /tmp/qemu-2.3.1 && make install


echo "UseDNS no" >> /etc/ssh/sshd_config
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

ls /etc/qemu
ls /etc/qemu/fsfreeze-hook.d
mkdir -p /etc/qemu/fsfreeze-hook.d
cat -n /etc/qemu/fsfreeze-hook
wget -O /etc/qemu/fsfreeze-hook https://raw.githubusercontent.com/qemu/qemu/master/scripts/qemu-guest-agent/fsfreeze-hook  --no-check-certificate
chmod +x /etc/qemu/fsfreeze-hook

echo '#!/bin/bash' > /etc/qemu/fsfreeze-hook.d/foo.sh
echo "case \"\$1\" in" >> /etc/qemu/fsfreeze-hook.d/foo.sh
echo "  freeze)" >> /etc/qemu/fsfreeze-hook.d/foo.sh
echo "    echo \"I'm frozen\" > /tmp/freeze" >> /etc/qemu/fsfreeze-hook.d/foo.sh
echo "    ;;" >> /etc/qemu/fsfreeze-hook.d/foo.sh
echo "  thaw)" >> /etc/qemu/fsfreeze-hook.d/foo.sh
echo "    bash /etc/qemu/script.sh 2>/etc/qemu/2 1>/etc/qemu/1" >> /etc/qemu/fsfreeze-hook.d/foo.sh
echo "    ;;" >> /etc/qemu/fsfreeze-hook.d/foo.sh
echo "  *)" >> /etc/qemu/fsfreeze-hook.d/foo.sh
echo "    exit 1" >> /etc/qemu/fsfreeze-hook.d/foo.sh
echo "    ;;" >> /etc/qemu/fsfreeze-hook.d/foo.sh
echo "esac" >> /etc/qemu/fsfreeze-hook.d/foo.sh

chmod +x /etc/qemu/fsfreeze-hook.d -R

echo 'FSFREEZE_HOOK_PATHNAME=/etc/qemu/fsfreeze-hook' > /etc/sysconfig/qemu-ga

rm /root/*
rm /etc/udev/rules.d/70-persistent-net.rules
rm /etc/sysconfig/network-scripts/ifcfg-eth0
echo 'DEVICE="eth0"' > /etc/sysconfig/network-scripts/ifcfg-eth0
echo 'BOOTPROTO="dhcp"' >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo 'IPV6INIT="yes"' >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo 'NM_CONTROLLED="yes"' >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo 'ONBOOT="yes"' >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo 'TYPE="Ethernet"' >> /etc/sysconfig/network-scripts/ifcfg-eth0

sed -i 's/write_rule "$match" "$INTERFACE" "$COMMENT"/#write_rule "$match" "$INTERFACE" "$COMMENT"/g' /lib/udev/write_net_rules
