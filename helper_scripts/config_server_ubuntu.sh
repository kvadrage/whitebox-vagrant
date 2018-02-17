#!/bin/bash

#This file is transferred to a Debian/Ubuntu Host and executed to re-map interfaces
#Extra config COULD be added here but I would recommend against that to keep this file standard.
echo "#################################"
echo "  Running Server Post Config"
echo "#################################"
sudo su -

# Shorten Boot Process - Applies to Ubuntu Only - remove \"Wait for Network\"
sed -i 's/sleep [0-9]*/sleep 1/' /etc/init/failsafe.conf || true

echo "  Adding admin user"
useradd -G sudo -s /bin/bash admin

sed "s/PasswordAuthentication no/PasswordAuthentication yes/" -i /etc/ssh/sshd_config
sed "s/#PermitRootLogin/PermitRootLogin/" -i /etc/ssh/sshd_config
sed "s/SELINUX=enforcing/SELINUX=disabled/" -i /etc/selinux/config

## Convenience code. This is normally done in ZTP.
echo "admin ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_admin
mkdir -p /home/admin/.ssh
mkdir -p /root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzH+R+UhjVicUtI0daNUcedYhfvgT1dbZXgY33Ibm4MOo+X84Iwuzirm3QFnYf2O3uyZjNyrA6fj9qFE7Ekul4bD6PCstQupXPwfPMjns2M7tkHsKnLYjNxWNql/rCUxoH2B6nPyztcRCass3lIc2clfXkCY9Jtf7kgC2e/dmchywPV5PrFqtlHgZUnyoPyWBH7OjPLVxYwtCJn96sFkrjaG9QDOeoeiNvcGlk4DJp/g9L4f2AaEq69x8+gBTFUqAFsD8ecO941cM8sa1167rsRPx7SK3270Ji5EUF3lZsgpaiIgMhtIB/7QNTkN9ZjQBazxxlNVN6WthF8okb7OSt" >> /home/admin/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzH+R+UhjVicUtI0daNUcedYhfvgT1dbZXgY33Ibm4MOo+X84Iwuzirm3QFnYf2O3uyZjNyrA6fj9qFE7Ekul4bD6PCstQupXPwfPMjns2M7tkHsKnLYjNxWNql/rCUxoH2B6nPyztcRCass3lIc2clfXkCY9Jtf7kgC2e/dmchywPV5PrFqtlHgZUnyoPyWBH7OjPLVxYwtCJn96sFkrjaG9QDOeoeiNvcGlk4DJp/g9L4f2AaEq69x8+gBTFUqAFsD8ecO941cM8sa1167rsRPx7SK3270Ji5EUF3lZsgpaiIgMhtIB/7QNTkN9ZjQBazxxlNVN6WthF8okb7OSt" >> /root/.ssh/authorized_keys

chmod 700 -R /home/admin/.ssh
chmod 700 -R /root/.ssh
chown admin:admin -R /home/admin/.ssh

cat << EOF > /etc/network/interfaces
source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto vagrant
iface vagrant inet dhcp

# internal mgmt
auto eth0
iface eth0 inet dhcp

EOF

# Other stuff
apt-get update
apt-get install lldpd iperf iperf3 tcpdump -y
apt-get install -y software-properties-common python-software-properties
add-apt-repository -y ppa:cz.nic-labs/bird
apt-get update
apt-get install bird -y

systemctl enable lldpd

echo "#################################"
echo "   Finished"
echo "#################################"
