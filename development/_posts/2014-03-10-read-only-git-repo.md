---
layout: post
title: Read Only Git Remotes
categories: [dev]
tags: [howto, git]
status: Published
type: article
published: 10 March 2014
meta:
  _edit_last: '1'

---

![The Git logo](http://upload.wikimedia.org/wikipedia/commons/e/e0/Git-logo.svg)

I'm a big fan of GitHub and Git in general. Instead of developing on the main repo on a branch I prefer to fork my own repo and work there. Then when I'm ready to commit upstream I can pull the main repo, merge, and then issue a pull request. One major flaw in this process is when I'm merging and I have Push privileges upstream I'm paranoid I'll commit to the wrong remote. I spent a few minutes today looking for a method of marking a remote 'read-only' and didn't see anything. 

A bit of Google brought me to a [Stack Overflow](http://stackoverflow.com/) [answer](http://stackoverflow.com/questions/10270027/can-i-mark-a-git-remote-as-read-only) that gives me what I needed.

TL;DR; Version:

```sh
git config remote.remote_name.pushurl "Disabled"
```

Protip: **remote_name** is the name of your remote you want as read-only. The example lists 'origin' but I wanted origin to be RW and 'upstream' to be RO so in my case I used 'upstream' in the command.
