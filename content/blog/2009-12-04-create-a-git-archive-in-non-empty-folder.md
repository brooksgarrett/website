---
title: Create a Git archive in non empty folder
tags:
- git
- tools
date: "04 Dec 2009"
slug: "create-a-git-archive-in-non-empty-folder"
---

```bash
git init
git remote add origin remote_machine:~brentg/my_setup.git
git fetch
git branch master origin/master
git checkout master
```
