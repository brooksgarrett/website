---
title: Manually Migrating Guests from Disconnected ESX Host
tags: [sysadmin]
date: "29 Aug 2013"
draft: false
slug: "disconnected-esx-host"
---

Earlier we lost the management interface on one of our ESX hosts in a cluster. The host was powered on and the guests were responsive but the host was completely unmanageable (listed as 'disconnected' in Sphere) and the guest VM's were listed as 'disconnected' as well.

Obviously we needed to reboot the host and migrate the VM's but that VMotion was out of the question. Finally we resorted to powering down the guest image and using the following steps to recover the guest machines on a new host.

1.  Get a console on the new, good host.
2.  Enable Local Tech Mode or Remote Tech Mode.
3.  Connect to the console of the new, good host.
4.  Execute the following commands.

 ```
 vim-cmd solo/registervm /vmfs/volumes/TARGET_LUN/PATH_TO_VM/GUEST_VM.vmx
 ```

5.  The output will be a number. Either use VSphere to power on the guest or use the number on the command line to boot the machine as follows.

 ```
 vim-cmd vmsvc/power.on NUMBER_FROM_LAST_COMMAND &
 vim-cmd vmsvc/message NUMBER_FROM_LAST_COMMAND 0 1
 ```
