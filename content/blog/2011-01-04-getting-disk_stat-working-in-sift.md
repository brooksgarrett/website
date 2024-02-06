---
title: Getting disk_stat Working in SIFT
tags: [forensics, volume analysis]
date: "04 Jan 2011"
slug: "getting-disk_stat-working-in-sift"
summary: This article provides a solution to an error encountered when running disk_stat in the SIFT (SANS Investigative Forensic Toolkit) Workstation VMWare appliance. The error occurs because the libssl.so.7 and libcrypto.so libraries are missing. The solution is to create symbolic links in /usr/lib pointing to these libraries.
---

SANS publishes the SIFT (SANS Investigative Forensic Toolkit) Workstation as a VMWare appliance.
The environment is impeccable for rolling out a mobile forensics workstation and is preloaded
with a wealth of tools. The workstation was created by Rob Lee.

All that being said, nothing is absolutely perfect. A huge drawback to the SIFT workstation is
getting disk_stat working so an investigator can detect HPA's on a suspect drive. Acquiring a disk
with an HPA requires additional steps and missing the HPA can mean missing evidence.

When you try to run disk_stat, you are given an error that the libssl.so.7 library could not be loaded.

```
sansforensics@SIFT-Workstation:/mnt/hgfs/Evidence/CASE001$ disk_stat
disk_stat: error while loading shared libraries: libssl.so.7: cannot open shared object file: No such file or directory
```

To fix this, create a symbolic link in /usr/lib pointing to libssl.so. You'll need to do the same for libcrypto.so as well.

```
sansforensics@SIFT-Workstation:/usr/lib$ sudo ln -s libssl.so libssl.so.7
sansforensics@SIFT-Workstation:/usr/lib$ sudo ln -s libcrypto.so libcrypto.so.7
```

All done! disk_stat will now properly detect HPA's on attached drives. Enojy!