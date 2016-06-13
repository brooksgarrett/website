---
date: "13 Jun 2016"
tags: [development, windows, git, powershell]
draft: false
title: Powershell Profile
---

I've nearly exclusively used Linux for all blogging, development, and research.
The Bash command line is just too powerful to ignore. Now with Microsoft making
major strides to improve PowerShell I'm finding myself spending more and more
time on my Windows machine.

This is my profile for Windows machines. Supports docker on the command line, rust and cargo, 
and generally lets me do whatever I want. I really haven't been missing Linux lately. That's 
crazy talk but entirely true.

```ps
# Set up PATH
$env:Path = "C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\Users\bg\path;" +
    "C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\GNU\GnuPG\pub;C:\Program Files\nodejs\;" +
    "C:\Users\bg\path\PortableGit\bin;C:\Python27;C:\Program Files\Rust stable GNU 1.9\bin;C:\Users\bg\.cargo\bin;" +
    "C:\Program Files\Docker Toolbox"
$env:GIT_SSH = "C:\Users\bg\path\plink.exe"
$PathLen = $env:Path.Length

# Rust variables
$env:RUST_SRC_PATH = "C:\Users\bg\Documents\Code\rust\src"

# Docker settings
$Env:DOCKER_TLS_VERIFY = "1"
$Env:DOCKER_HOST = "tcp://192.168.1.254:2376"
$Env:DOCKER_CERT_PATH = "C:\Users\bg\.docker\machine\machines\default"
$Env:DOCKER_MACHINE_NAME = "default"

# Aliases
function bg() { Start-Process -NoNewWindow @args}
set-alias code "bg C:\Program Files (x86)\Microsoft VS Code\Code.exe" 
set-alias reload "C:\Users\bg\Documents\WindowsPowerShell\profile.ps1"

# Warn if admin
If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You are executing as ADMIN"
} Else

{Write-Output "You are executing with limited privileges."}

Write-Host "Profile loaded with ENV Length of $PathLen"
```