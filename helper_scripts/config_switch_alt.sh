#!/bin/bash

#This file is transferred to the Cumulus VX and executed to re-map interfaces
#Extra config COULD be added here but I would recommend against that to keep this file standard.
echo "#################################"
echo "  Running Switch Post Config"
echo "#################################"
sudo su

echo "  Adding admin user"
useradd -G wheel -s /bin/bash admin

echo "  Configuring hostname"
test -n "$1" && sed -i "s/HOSTNAME=.*$/HOSTNAME=$1/g" /etc/sysconfig/network

echo "  Configuring interfaces"
cat <<EOF > /etc/rc.d/rc.netinit
# bring up the loopback device and let the kernel to autoconfigure it
ip link set dev lo up

# Try to get address automatically
ip link set dev eth0 down
ip link set dev eth0 name vagrant up
dhcpcd -p -w vagrant && dhcpcd -x vagrant

# Configure the netfilter subsystem (kernel firewall)
test -x /etc/rc.d/rc.firewall \
&& /etc/rc.d/rc.firewall

# sysctl tweaks
## Turn on IP packet forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
## enable 5-tuple hashing for ECMP
echo 1 > /proc/sys/net/ipv4/fib_multipath_hash_policy

## enable linkdown and addr down
echo 1 > /proc/sys/net/ipv6/conf/all/keep_addr_on_down
echo 1 > /proc/sys/net/ipv4/conf/default/ignore_routes_with_linkdown

## enable services binding to VRFs
echo 1 > /proc/sys/net/ipv4/tcp_l3mdev_accept
echo 1 > /proc/sys/net/ipv4/udp_l3mdev_accept

# tune TCP in kernel
echo 0 > /proc/sys/net/ipv4/tcp_syncookies
echo 4096 > /proc/sys/net/core/somaxconn

EOF

## Convenience code. This is normally done in ZTP.
echo "  Configuring SSH keys"
mkdir -p /root/.ssh
mkdir -p /home/admin/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzH+R+UhjVicUtI0daNUcedYhfvgT1dbZXgY33Ibm4MOo+X84Iwuzirm3QFnYf2O3uyZjNyrA6fj9qFE7Ekul4bD6PCstQupXPwfPMjns2M7tkHsKnLYjNxWNql/rCUxoH2B6nPyztcRCass3lIc2clfXkCY9Jtf7kgC2e/dmchywPV5PrFqtlHgZUnyoPyWBH7OjPLVxYwtCJn96sFkrjaG9QDOeoeiNvcGlk4DJp/g9L4f2AaEq69x8+gBTFUqAFsD8ecO941cM8sa1167rsRPx7SK3270Ji5EUF3lZsgpaiIgMhtIB/7QNTkN9ZjQBazxxlNVN6WthF8okb7OSt" >> /root/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzH+R+UhjVicUtI0daNUcedYhfvgT1dbZXgY33Ibm4MOo+X84Iwuzirm3QFnYf2O3uyZjNyrA6fj9qFE7Ekul4bD6PCstQupXPwfPMjns2M7tkHsKnLYjNxWNql/rCUxoH2B6nPyztcRCass3lIc2clfXkCY9Jtf7kgC2e/dmchywPV5PrFqtlHgZUnyoPyWBH7OjPLVxYwtCJn96sFkrjaG9QDOeoeiNvcGlk4DJp/g9L4f2AaEq69x8+gBTFUqAFsD8ecO941cM8sa1167rsRPx7SK3270Ji5EUF3lZsgpaiIgMhtIB/7QNTkN9ZjQBazxxlNVN6WthF8okb7OSt" >> /home/admin/.ssh/authorized_keys
chmod 700 -R /root/.ssh
chmod 700 -R /home/admin/.ssh

echo "#################################"
echo "   Finished"
echo "#################################"
