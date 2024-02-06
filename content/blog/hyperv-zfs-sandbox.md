---
date: "27 Jun 2016"
tags: [development, windows, zfs]
draft: false
title: ZFS Sandbox in Hyper-V
summary: This article provides a step-by-step guide on how to set up a ZFS sandbox in Hyper-V to test the behavior of ZFS when it crashes.
---

[ZFS](https://en.wikipedia.org/wiki/ZFS) has arrived on [Ubuntu 16.04 LTS](https://insights.ubuntu.com/2016/02/16/zfs-is-the-fs-for-containers-in-ubuntu-16-04/) and that means it's time to upgrade my NAS. Since my NAS houses all my kids pictures I want it to be redundant but performant. 
I like the ability to dedup as well as snapshot (and remotely backup those snapshots) that ZFS offers. Before I actually trust my data to a new technology I need to
be sure I know how it behaves when it crashes. Hard.

To HYPER-V! 

Things I have:

+  Windows 10
+  Hyper-V
+  Powershell
+  [Hyper-V Cmdlets Documentation](https://technet.microsoft.com/en-us/library/hh848559.aspx)
+  [Ubuntu 16.04 LTS Mini ISO](http://cdimage.ubuntu.com/lubuntu/releases/16.04/release/lubuntu-16.04-desktop-amd64.iso)

First, I wrote a simple Powershell script that will provision all my drives for me. The script will create a new VM, set it to boot from 
the Ubuntu ISO, attach a stack of SCSI disks, and boot the VM. Once it's up simply install a base Ubuntu machine as normal. 

**Note:** I call my direct connect network "Docker" since that's what's running on that network. Replace "Docker" below with whatever your Hyper-V 
network is called.

```powershell
New-Vm -name Zfs_Sandbox -NoVHD -SwitchName Docker -path .\Zfs_Sandbox -MemoryStartupBytes 1GB -Generation 1
# Download http://archive.ubuntu.com/ubuntu/dists/xenial/main/installer-amd64/current/images/netboot/mini.iso
Set-VMDvdDrive -VMName "Zfs_Sandbox" -ControllerNumber 1 -Path .\mini.iso
new-vhd -Dynamic -SizeBytes 8GB -Path .\Zfs_Sandbox\zfs_os.vhdx
new-vhd -Dynamic -SizeBytes 1GB -Path .\Zfs_Sandbox\zfs_1.vhdx
new-vhd -Dynamic -SizeBytes 1GB -Path .\Zfs_Sandbox\zfs_2.vhdx
new-vhd -Dynamic -SizeBytes 1GB -Path .\Zfs_Sandbox\zfs_3.vhdx
new-vhd -Dynamic -SizeBytes 1GB -Path .\Zfs_Sandbox\zfs_4.vhdx
new-vhd -Dynamic -SizeBytes 1GB -Path .\Zfs_Sandbox\zfs_5.vhdx
Add-VMHardDiskDrive -VMName "Zfs_Sandbox" -ControllerType IDE  -ControllerNumber 0 -Path .\Zfs_Sandbox\zfs_os.vhdx
Add-VMHardDiskDrive -VMName "Zfs_Sandbox" -ControllerType SCSI -ControllerNumber 0 -Path .\Zfs_Sandbox\zfs_1.vhdx
Add-VMHardDiskDrive -VMName "Zfs_Sandbox" -ControllerType SCSI -ControllerNumber 0 -Path .\Zfs_Sandbox\zfs_2.vhdx
Add-VMHardDiskDrive -VMName "Zfs_Sandbox" -ControllerType SCSI -ControllerNumber 0 -Path .\Zfs_Sandbox\zfs_3.vhdx
Add-VMHardDiskDrive -VMName "Zfs_Sandbox" -ControllerType SCSI -ControllerNumber 0 -Path .\Zfs_Sandbox\zfs_4.vhdx
Start-VM -VMName Zfs_Sandbox
```

Next we need to update the machine and install ZFS.

```bash
apt upgrade
apt install zfsutils-linux
```

We're set! ZFS is similar to LVM in that it's an abstracted form of looking at storage. In both you have the concept of a Volume that is made up of some Virtual 
Devices which in turn may be real block devices, partitions, or even files. With ZFS there is no formatting or partition management. You have a ZPool (think "mount point")
which is made of vdevs (Virtual devices) which are made of real devices. Let's create a simple pool. First we learn the *zpool* command. As you see there are no 
pools by default. We'll need to create them using *zpool create*.

```bash
root@zfs-sandbox:~# zpool status
no pools available
root@zfs-sandbox:~# zpool create test_pool sdb
root@zfs-sandbox:~# zpool status
  pool: test_pool
 state: ONLINE
  scan: none requested
config:

        NAME        STATE     READ WRITE CKSUM
        test_pool   ONLINE       0     0     0
          sdb       ONLINE       0     0     0

errors: No known data errors
root@zfs-sandbox:~# mount
[...]
test_pool on /test_pool type zfs (rw,relatime,xattr,noacl)
```

So you see we've created a zpool named *test_pool* and it has one virtual device */dev/sdb* which is also the real */dev/sdb*. Nothing too exciting. Now what if we start 
adding a mirror into the mix?

```bash
root@zfs-sandbox:~# zpool destroy test_pool
root@zfs-sandbox:~# zpool create test_pool mirror sdb sdc
root@zfs-sandbox:~# zpool status
  pool: test_pool
 state: ONLINE
  scan: none requested
config:

        NAME        STATE     READ WRITE CKSUM
        test_pool   ONLINE       0     0     0
          mirror-0  ONLINE       0     0     0
            sdb     ONLINE       0     0     0
            sdc     ONLINE       0     0     0

errors: No known data errors
root@zfs-sandbox:~# zpool list
NAME        SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
test_pool  1008M   284K  1008M         -     0%     0%  1.00x  ONLINE  -
```

Ok, we destroyed the *test_pool* and recreated it this time as a mirror. Remember our powershell gave us 6 disks of 1GB each. So you see we used *sdb* and *sdc* in 
a RAID1 (mirror) configuration which means we only have 1/2 the usable space. We now have a zpool named *test_pool* which is comprised of a single vdev called *mirror-0* and
 in turn is comprised of *sdb* and *sdc*. If you want to add more space you can add a new virtual device. 

```bash
 root@zfs-sandbox:~# zpool add test_pool sdd
invalid vdev specification
use '-f' to override the following errors:
mismatched replication level: pool uses mirror and new vdev is disk
root@zfs-sandbox:~# zpool add -f test_pool sdd
root@zfs-sandbox:~# zpool list
NAME        SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
test_pool  1.97G   684K  1.97G         -     0%     0%  1.00x  ONLINE  -
root@zfs-sandbox:~# zpool status
  pool: test_pool
 state: ONLINE
  scan: none requested
config:

        NAME        STATE     READ WRITE CKSUM
        test_pool   ONLINE       0     0     0
          mirror-0  ONLINE       0     0     0
            sdb     ONLINE       0     0     0
            sdc     ONLINE       0     0     0
          sdd       ONLINE       0     0     0

errors: No known data errors
```

ZFS will let you add a single device (if you force it) or a mirror. It's up to you. Considering you want redundancy it's best to have matching RAID levels across all 
virtual devices. I'll go back and alter that single disk and make it a mirror instead.

```bash
root@zfs-sandbox:~# zpool attach test_pool sdd sde
root@zfs-sandbox:~# zpool status
  pool: test_pool
 state: ONLINE
  scan: resilvered 40K in 0h0m with