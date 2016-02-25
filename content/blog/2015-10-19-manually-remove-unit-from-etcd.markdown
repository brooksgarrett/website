---
title: "Manually remove unit from etcd"
date: "19 Oct 2015"
tags: [community,social]
slug: "manually-remove-unit-from-etcd"
---

Long story short I was playing with Docker and got myself into quite the bind.
After deploying a nice and easy [test cluster][b5a97b28] I decided to have a go
with [Consul][4f7f25c3] using the "official" [Consul on CoreOS][d25060d0]. Big
problem because that Dockerfile expects you to be running "etcd" while my
cluster is running "etcd2"! That means it breaks etcd, fleet, and the entire
CoreOS system. As a bonus, since CoreOS handles HA it then proceeds to _BREAK
THE WHOLE CLUSTER_.

So you reboot. _Still broken._ So friends let us now remove that god awful unit
manually from Fleet by way of etcd.

First let's kill all the services:

```bash
localhost ~ $ systemctl stop docker
localhost ~ $ systemctl stop fleet
localhost ~ $ systemctl stop etcd
```

Start etcd2 back up:

```bash
localhost ~ $ systemctl start etcd2
```

Is it working? On my instance I wrote a test node called "/msg" with a value of
"Looking good". If I get /msg and see "Looking good" then I know I'm connected
back to the central etcd cluster.

```bash
localhost ~ $ etcdctl get /msg
Looking good.
```

Fleet keeps all of its configuration in a hidden node under _/_coreos.com/fleet_
so we can start there. We need to find and kill the bad unit (consul@.service).
The unit is kept under _unit_ and we also need to remove the _job_.

```bash
localhost ~ $ etcdctl ls /_coreos.com/fleet # Fleet's nodes
/_coreos.com/fleet/job
/_coreos.com/fleet/engine
/_coreos.com/fleet/lease
/_coreos.com/fleet/machines
/_coreos.com/fleet/unit
localhost ~ $ etcdctl ls /_coreos.com/fleet/unit
/_coreos.com/fleet/unit/0fc6e0b73dc6b02da675b13023c6587850eb603a
localhost ~ $ etcdctl get /_coreos.com/fleet/unit/0fc6e0b73dc6b02da675b13023c6587850eb603a
{"Raw":"[Unit]\nDescription=Consul...snipped..."}
localhost ~ $ etcdctl rm /_coreos.com/fleet/unit/0fc6e0b73dc6b02da675b13023c6587850eb603a
```

That takes care of the unit. Now the job is actually a directory so we need to
use a [recursive delete][024d3321] here.

```bash
localhost ~ $ etcdctl ls /_coreos.com/fleet/job
/_coreos.com/fleet/job/consul@.service
/_coreos.com/fleet/job/consul@1.service
localhost ~ $ etcdctl rm --recursive /_coreos.com/fleet/job/consul@1.service
localhost ~ $ etcdctl rm --recursive /_coreos.com/fleet/job/consul@.service
```

Looking good. Now we reboot and return to your normally scheduled containers!



  [b5a97b28]: https://coreos.com/os/docs/latest/cluster-architectures.html "Cluster Architectures"
  [4f7f25c3]: https://www.consul.io/ "Consul"
  [d25060d0]: https://github.com/democracyworks/consul-coreos "Consul on CoreOS - GitHub"
  [024d3321]: https://github.com/coreos/etcd/tree/master/etcdctl#deleting-a-key "Etcd Deleting a Key"
