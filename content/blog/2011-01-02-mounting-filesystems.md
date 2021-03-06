---
title: Mounting Filesystems
date: "02 Jan 2011"
slug: mounting-filesystems
tags: [forensics, volume analysis]

---
When mounting an image of a journaled filesystem, a couple of shortcuts repeatedly save me time and energy. First, VFAT and NTFS disks reserve (generally) the first 63 sectors for the partition table and meta info. Considering 512 is a very common size for sectors, 32256 becomes a very good number to remember.

> 32256 is the number of bytes you generally need to offset when mounting a volume.

This offset is done in mount as follows:
<blockquote>sudo mount -t [vfat, ntfs-3g, etc] -o ro,loop,offset=32256 /path/to/image /path/to/mountpoint</blockquote>
Excellent, so now we have our drive image (loop) mounted as a read-only (ro) volume and we told the mount command that the partition we are interested in begins 32,256 bytes into the image (63 sectors * 512 bytes per sector = 32,256 bytes; Thus offset=32256). A big problem with mounting journaled filesystems is their meta data. As a forensic investigator, you can not change the evidence volume. However, even when mounting a volume ro, the metadata still changes by incrementing the "times mounted" count.  To avoid this, set the permissions on the image file itself to 444 or less (I prefer 440). This will prevent the counter increase and preserve your sound image.
