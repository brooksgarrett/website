---
date: "14 Jun 2016"
tags: [development, windows, git]
draft: false
title: Docker in Azure
---

I'm playing with Docker and have it set up locally in Hyper-V for testing. I really want to have a public/internet facing host though. I remembered I had some free
Azure credits from my MSDN Subscription so that's where I'm getting started.

Things I have:

+  MSDN Account
+  [Azure Account](https://manage.windowsazure.com/)
+  [Docker Toolbox](https://www.docker.com/products/docker-toolbox) installed
+  [My Powershell Profile](https://brooksgarrett.com/blog/powershell-profile-one/)

First, use Docker Machine to establish your Docker VM in Azure. Of important note are the -d (driver) argument and the Subscriber ID. You find that in your 
"Settings" in the Azure portal.

```
PS C:\Users\bg> docker-machine.exe create -d azure --azure-subscription-id o.b.f.u.s.c.a.t.e.d public
Running pre-create checks...
(public) Microsoft Azure: To sign in, use a web browser to open the page https://aka.ms/devicelogin. Enter the code FJP4
VWRS3 to authenticate.
(public) Completed machine pre-create checks.
Creating machine...
(public) Querying existing resource group.  name="docker-machine"
(public) Creating resource group.  name="docker-machine" location="westus"
(public) Configuring availability set.  name="docker-machine"
(public) Configuring network security group.  name="public-firewall" location="westus"
(public) Querying if virtual network already exists.  location="westus" name="docker-machine-vnet"
(public) Configuring subnet.  name="docker-machine" vnet="docker-machine-vnet" cidr="192.168.0.0/16"
(public) Creating public IP address.  name="public-ip" static=false
(public) Creating network interface.  name="public-nic"
(public) Creating storage account.  name="obfuscated" location="westus"
(public) Creating virtual machine.  name="public" location="westus" size="Standard_A2" username="docker-user" osImage="c
anonical:UbuntuServer:15.10:latest"
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with ubuntu(systemd)...
Installing Docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: C:\Program Files\Doc
ker Toolbox\docker-machine.exe env public
PS C:\Users\bg> docker-machine.exe ls
NAME      ACTIVE   DRIVER   STATE     URL                       SWARM   DOCKER    ERRORS
default   -        hyperv                                               Unknown
public    -        azure    Running   tcp://13.91.40.169:2376           v1.11.2
PS C:\Users\bg> docker-machine.exe env public
$Env:DOCKER_TLS_VERIFY = "1"
$Env:DOCKER_HOST = "tcp://13.91.40.169:2376"
$Env:DOCKER_CERT_PATH = "C:\Users\bg\.docker\machine\machines\public"
$Env:DOCKER_MACHINE_NAME = "public"
# Run this command to configure your shell:
# & "C:\Program Files\Docker Toolbox\docker-machine.exe" env public | Invoke-Expression
PS C:\Users\bg> & "C:\Program Files\Docker Toolbox\docker-machine.exe" env public | Invoke-Expression
PS C:\Users\bg> docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

```

