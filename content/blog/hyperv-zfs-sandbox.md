---
date: "27 Jun 2016"
tags: [development, windows, zfs]
draft: false
title: ZFS Sandbox in Hyper-V
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
  scan: resilvered 40K in 0h0m with 0 errors on Mon Jun 27 16:22:13 2016
config:

        NAME        STATE     READ WRITE CKSUM
        test_pool   ONLINE       0     0     0
          mirror-0  ONLINE       0     0     0
            sdb     ONLINE       0     0     0
            sdc     ONLINE       0     0     0
          mirror-1  ONLINE       0     0     0
            sdd     ONLINE       0     0     0
            sde     ONLINE       0     0     0

errors: No known data errors
root@zfs-sandbox:~# zpool list
NAME        SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
test_pool  1.97G   660K  1.97G         -     0%     0%  1.00x  ONLINE  -
```

Now we have a RAID10 setup. So what happens when we lose a disk? With our Powershell prompt we can rapidly see! It's important to note that ZFS only really health-checks when
it writes data or when you manually run the *zpool scrub* command. With that in mind let's nuke a disk in Powershell and see what happens...

```powershell
Remove-VMHardDiskDrive -VmName zfs_sandbox -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 1
```

Now let's see what happens in our ZFS zpool.

```bash
root@zfs-sandbox:~# touch /test_pool/demo
root@zfs-sandbox:~# zpool status
  pool: test_pool
 state: DEGRADED
status: One or more devices could not be used because the label is missing or
        invalid.  Sufficient replicas exist for the pool to continue
        functioning in a degraded state.
action: Replace the device using 'zpool replace'.
   see: http://zfsonlinux.org/msg/ZFS-8000-4J
  scan: resilvered 40K in 0h0m with 0 errors on Mon Jun 27 16:22:13 2016
config:

        NAME        STATE     READ WRITE CKSUM
        test_pool   DEGRADED     0     0     0
          mirror-0  DEGRADED     0     0     0
            sdb     ONLINE       0     0     0
            sdc     UNAVAIL      0     0     0
          mirror-1  ONLINE       0     0     0
            sdd     ONLINE       0     0     0
            sde     ONLINE       0     0     0

errors: No known data errors
```

Up until now I've failed to mention that ZFS mounts at the Pool Name (in this case */test_pool*.) I should also mention you can see the *ControllerLocation* with this command:

```Powershell
Get-VMHardDiskDrive -VMName zfs_sandbox

VMName      ControllerType ControllerNumber ControllerLocation DiskNumber Path
------      -------------- ---------------- ------------------ ---------- ----
Zfs_Sandbox IDE            0                0                             C:\Users\bg\Documents\VHD\Zfs_Sandbox\Zfs_Sandbox\zfs_os.vhdx
Zfs_Sandbox SCSI           0                0                             C:\Users\bg\Documents\VHD\Zfs_Sandbox\Zfs_Sandbox\zfs_1.vhdx
Zfs_Sandbox SCSI           0                3                             C:\Users\bg\Documents\VHD\Zfs_Sandbox\Zfs_Sandbox\zfs_r4.vhdx
Zfs_Sandbox SCSI           0                4                             C:\Users\bg\Documents\VHD\Zfs_Sandbox\Zfs_Sandbox\zfs_2.vhdx
Zfs_Sandbox SCSI           0                5                             C:\Users\bg\Documents\VHD\Zfs_Sandbox\Zfs_Sandbox\zfs_3.vhdx
```

When I create a file ZFS suddenly sees a problem but it has enough redundancy to keep going. If we lost *sdb* then we'd be in real trouble. As it is, things are OK for now. 
Let's see if we can kill another disk!

```Powershell
Remove-VMHardDiskDrive -VmName zfs_sandbox -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 3
```

```bash
root@zfs-sandbox:~# zpool scrub test_pool
root@zfs-sandbox:~# zpool status
  pool: test_pool
 state: DEGRADED
status: One or more devices could not be used because the label is missing or
        invalid.  Sufficient replicas exist for the pool to continue
        functioning in a degraded state.
action: Replace the device using 'zpool replace'.
   see: http://zfsonlinux.org/msg/ZFS-8000-4J
  scan: scrub repaired 0 in 0h0m with 0 errors on Mon Jun 27 16:30:59 2016
config:

        NAME        STATE     READ WRITE CKSUM
        test_pool   DEGRADED     0     0     0
          mirror-0  DEGRADED     0     0     0
            sdb     ONLINE       0     0     0
            sdc     UNAVAIL      0     0     0
          mirror-1  DEGRADED     0     0     0
            sdd     UNAVAIL      0     0     0  corrupted data
            sde     ONLINE       0     0     0

errors: No known data errors
```

Things are getting bad! One more drive and we lose our data! I happen to have a spare drive on *sdf*. To recover we have a couple of options. First, I'll use 
Powershell to put *sdc* back where it belongs. Then, I have an extra drive on *sdf* which I'll add as a "hot spare" and then swap in to repair mirror-0.

```Powershell 
Add-VMHardDiskDrive -VmName zfs_sandbox -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 1 -Path .\Zfs_Sandbox\Zfs_Sandbox\zfs_4.vhdx
```

```bash
root@zfs-sandbox:~# zpool scrub test_pool
root@zfs-sandbox:~# zpool status
  pool: test_pool
 state: DEGRADED
status: One or more devices could not be used because the label is missing or
        invalid.  Sufficient replicas exist for the pool to continue
        functioning in a degraded state.
action: Replace the device using 'zpool replace'.
   see: http://zfsonlinux.org/msg/ZFS-8000-4J
  scan: scrub repaired 112K in 0h0m with 0 errors on Mon Jun 27 16:34:58 2016
config:

        NAME        STATE     READ WRITE CKSUM
        test_pool   DEGRADED     0     0     0
          mirror-0  ONLINE       0     0     0
            sdb     ONLINE       0     0     0
            sdc     ONLINE       0     0    28
          mirror-1  DEGRADED     0     0     0
            sdd     UNAVAIL      0     0     0
            sde     ONLINE       0     0     0

errors: No known data errors
```

First we see our restored disk come back on-line and magically fix itself. Next we use a spare to repair the other mirror.

```bash
root@zfs-sandbox:~# zpool add test_pool spare sdf
root@zfs-sandbox:~# zpool status
  pool: test_pool
 state: DEGRADED
status: One or more devices could not be used because the label is missing or
        invalid.  Sufficient replicas exist for the pool to continue
        functioning in a degraded state.
action: Replace the device using 'zpool replace'.
   see: http://zfsonlinux.org/msg/ZFS-8000-4J
  scan: scrub repaired 112K in 0h0m with 0 errors on Mon Jun 27 16:34:58 2016
config:

        NAME        STATE     READ WRITE CKSUM
        test_pool   DEGRADED     0     0     0
          mirror-0  ONLINE       0     0     0
            sdb     ONLINE       0     0     0
            sdc     ONLINE       0     0    28
          mirror-1  DEGRADED     0     0     0
            sdd     UNAVAIL      0     0     0
            sde     ONLINE       0     0     0
        spares
          sdf       AVAIL

errors: No known data errors
root@zfs-sandbox:~# zpool replace sdd sdf
cannot open 'sdd': no such pool
root@zfs-sandbox:~# zpool replace test_pool sdd sdf
root@zfs-sandbox:~# zpool status
  pool: test_pool
 state: DEGRADED
status: One or more devices could not be used because the label is missing or
        invalid.  Sufficient replicas exist for the pool to continue
        functioning in a degraded state.
action: Replace the device using 'zpool replace'.
   see: http://zfsonlinux.org/msg/ZFS-8000-4J
  scan: resilvered 88K in 0h0m with 0 errors on Mon Jun 27 16:35:40 2016
config:

        NAME         STATE     READ WRITE CKSUM
        test_pool    DEGRADED     0     0     0
          mirror-0   ONLINE       0     0     0
            sdb      ONLINE       0     0     0
            sdc      ONLINE       0     0    28
          mirror-1   DEGRADED     0     0     0
            spare-0  UNAVAIL      0     0     0
              sdd    UNAVAIL      0     0     0
              sdf    ONLINE       0     0     0
            sde      ONLINE       0     0     0
        spares
          sdf        INUSE     currently in use

errors: No known data errors
root@zfs-sandbox:~#
```

Now you see that *sdf* is being attached with *sdd*. The *spare-0* label indicates a spare is in use. Once we replace or repair *sdd* we can move our spare back
out of the mirror. Let's use our Powershell to do that now.

```powershell

```

And now let's tell zpool to repair itself and move our spare back to spare status!

```bash
root@zfs-sandbox:~# zpool detach test_pool sdf
root@zfs-sandbox:~# zpool status
  pool: test_pool
 state: ONLINE
status: One or more devices has experienced an unrecoverable error.  An
        attempt was made to correct the error.  Applications are unaffected.
action: Determine if the device needs to be replaced, and clear the errors
        using 'zpool clear' or replace the device with 'zpool replace'.
   see: http://zfsonlinux.org/msg/ZFS-8000-9P
  scan: scrub repaired 88K in 0h0m with 0 errors on Mon Jun 27 16:39:13 2016
config:

        NAME        STATE     READ WRITE CKSUM
        test_pool   ONLINE       0     0     0
          mirror-0  ONLINE       0     0     0
            sdb     ONLINE       0     0     0
            sdc     ONLINE       0     0    28
          mirror-1  ONLINE       0     0     0
            sdd     ONLINE       0     0     0
            sde     ONLINE       0     0     0
        spares
          sdf       AVAIL

errors: No known data errors
```

That's it! We now have a sandbox where we can kill and recover disks at will and see how ZFS reacts. 
