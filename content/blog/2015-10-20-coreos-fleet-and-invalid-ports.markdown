---
title: "CoreOS, Fleet, and Invalid Ports"
date: "20 Oct 2015"
tags: [community,social]
slug: "coreos-fleet-and-invalid-ports"
---

I kept getting this error today while trying to launch a unit in fleet:

```bash
Oct 20 15:54:03 coreos02 docker[3542]: docker: Invalid containerPort: -p.
Oct 20 15:54:03 coreos02 docker[3542]: See '/usr/bin/docker run --help'.
Oct 20 15:54:03 coreos02 systemd[1]: consul@1.service: Main process exited, code=exited, status=1/FAILURE
Oct 20 15:54:03 coreos02 systemd[1]: consul@1.service: Unit entered failed state.
Oct 20 15:54:03 coreos02 systemd[1]: consul@1.service: Failed with result 'exit-code'.
```

I added a _ExecStartPre_ command to my unit definition to see what was going on.
In summary, it looks like several "normal" ways of including environment
variables don't jive with CoreOS. Here is a demo unit showing the different ways.

```bash
ExecStartPre=/usr/bin/echo -p ${COREOS_PUBLIC_IPV4}:8300:8300 -p "$COREOS_PUBLIC_IPV4":8301:8301 -p "$(COREOS_PUBLIC_IPV4)":8301:8301/udp -p "$(/usr/bin/echo COREOS_PUBLIC_IPV4)":8301:8301/udp -advertise $COREOS_PUBLIC_IPV4
```

```bash
Unit consul@1.service launched on 90f32579.../192.168.1.220
-- Logs begin at Mon 2015-10-19 19:12:25 UTC, end at Tue 2015-10-20 15:58:29 UTC. --
Oct 20 15:58:28 coreos02 docker[3643]: Status: Image is up to date for progrium/consul:latest
Oct 20 15:58:28 coreos02 etcdctl[3649]: Error:  105: Key already exists (/consul) [43558]
Oct 20 15:58:28 coreos02 echo[3657]: -p 192.168.1.220:8300:8300 -p -p -p -advertise 192.168.1.220
Oct 20 15:58:28 coreos02 echo[3660]: -p -p -p -adverrtise 192.168.1.220
Oct 20 15:58:28 coreos02 systemd[1]: Started Consul.
Oct 20 15:58:28 coreos02 docker[3664]: docker: Invalid containerPort: -p.
Oct 20 15:58:28 coreos02 docker[3664]: See '/usr/bin/docker run --help'.
Oct 20 15:58:28 coreos02 systemd[1]: consul@1.service: Main process exited, code=exited, status=1/FAILURE
Oct 20 15:58:28 coreos02 systemd[1]: consul@1.service: Unit entered failed state.
Oct 20 15:58:28 coreos02 systemd[1]: consul@1.service: Failed with result 'exit-code'.
```

As you can see, only surrounding the variable with curly braces _{ }_ works. So
if you need to pass the IP address of the host to your containers via
environment variable, use { and }.
