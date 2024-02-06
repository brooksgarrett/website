---
title: Create a Git archive in non empty folder
tags:
- git
- tools
date: "04 Dec 2009"
slug: "create-a-git-archive-in-non-empty-folder"
summary: A guide on how to create a Git archive in a non-empty folder by initializing a Git repository, adding a remote, fetching the remote repository, creating a local branch, and checking out the local branch.
---

```bash
git init
git remote add origin remote_machine:~brentg/my_setup.git
git fetch
git branch master origin/master
git checkout master
```