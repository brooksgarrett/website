---
title: Renaming Volume Groups in Linux
tags: [sysadmin]
date: "09 Mar 2013"
draft: false
slug: "renaming-volume-groups-in-linux"
summary: This article provides a step-by-step guide on how to rename volume groups in Linux. It includes instructions on changing the kernel boot parameters, remounting the filesystem, editing the /etc/fstab and /etc/grub.conf files, and rebooting the system to complete the renaming process.
---
What is that you say? Cloned a Linux machine and decided to rename that misnamed volume group using <em>vgrename /dev/vg_RAWRStupidName /dev/vg_NiceName</em>?
Oh and now your rebooted without first changing your <em>/etc/fstab</em> and <em>/etc/grub.conf</em> and get a good old fashioned <strong>Kernel Panic</strong>?
Well lucky you I remembered to write this down:

1.  When booting go into the Edit mode for Grub (Generally ESC during boot).
1.  Change the kernel boot parameters to reference your new VG name.
1.  Press Enter and then B to boot.
1.  Once you boot, remount the filesystem RW so you can edit it (At this point you've likely failed a FSCK and landed in rescue mode. If not, do 5 then skip to number 8.
1.  Remounting is done with *mount -o remount,rw /*
1.  Edit your */etc/fstab* with the new VG name.
1.  Reboot
1.  Repeat step 1-3
1.  Edit */etc/grub.conf* with your new VG name
1.  Breathe deep.