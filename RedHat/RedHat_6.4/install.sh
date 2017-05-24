#!/bin/bash

yum -y update python
yum -y install openssh-server
chkconfig sshd on
systemctl enable sshd.service
# conflicts with file from package redhat-rpm-config-9.1.0-68.el7.centos.noarch
#yum -y install http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum -y install cloud-init

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
