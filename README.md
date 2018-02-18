# whitebox-vagrant
Vagrant topology for ALT netdev virtual routers and RHEL/CentOS servers.
Based on https://github.com/CumulusNetworks/cldemo-vagrant.
Automate with [whitebox-provision](https://github.com/kvadrage/whitebox-provision) Ansible playbook.
## Overview
VMs:
* **oob-mgmt-server** - management VM (Ubuntu)
* **leaf[01-04]** - leaf switches (ALT)
* **spine[01-04]** - spine switches (ALT)
* **server[01-04]** - servers (CentOS)

Host HW requirements:
* CPU: 2-4 cores/vCPU
* RAM: 8Gb minimal, 16Gb recommended
* Disk: 25Gb

Host SW requirements:
* VirtualBox 5.x.x
* vagrant 2.0.2

Tested on:
* MacOS 10.11 (El Capitan), Vagrant 2.0.2, VirtualBox 5.1.14
* Windows 10 Pro, Vagrant 2.0.2, VirtualBox 5.2.4

## Network topology
```
      | |                                                   | |
      | |                                                   | |
    +-5-6---------+   +-------------+   +-------------+   +-5-6---------+
    |   spine01   |   |   spine02   |   |   spine03   |   |   spine04   |
    +-1-2-3-4-----+   +-1-2-3-4-----+   +-1-2-3-4-----+   +-1-2-3-4-----+
      |                 |                 |                 |
      | +---------------+                 |                 |
      | | +-------------------------------+                 |
      | | | +-----------------------------------------------+
      | | | |           | | | |           | | | |            | | | |
      | | | |           | | | |           | | | |            | | | |
    +-1-2-3-4-----+   +-1-2-3-4-----+   +-1-2-3-4-----+   +--1-2-3-4----+
    |   leaf01    |   |   leaf02    |   |   leaf03    |   |   leaf04    |
    +-5s0--5s1----+   +-5s+--5s1----+   +-5s0--5s1----+   +--5s0--5s1---+
      |    |            |    |            |    |            |    |
      |    |            |    |            |    |            |    |
      |    | +--------+ |    |            |    | +--------+ |    |
      |    11|server01|12    |            |    11|server02|12    |
      |      +--------+      |            |      +--------+      |
      |                      |            |                      |
      |      +--------+      |            |      +--------+      |
      +----11|server03|12----+            +----11|server04|12----+
             +--------+                          +--------+

```

## Funtionality
* L3 routing (IPv4/IPv6)
* BGP/OSPF/BFD (Bird)
* VRF support

# Usage
* host# `git clone https://github.com/kvadrage/whitebox-vagrant && cd whitebox-vagrant`
* host# `vagrant up`
* host# `vagrant ssh oob-mgmt-server`
* oob-mgmt-server# `sudo su - admin` (if was logged as a different user)
* Now you have key-based ssh access to all VMs: `ssh leaf01`
