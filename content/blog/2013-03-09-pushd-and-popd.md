---
title: pushd and popd
tags: [sysadmin, linux]
date: "09 Mar 2013"
slug: pushd-and-popd
---
I don't know how I've gone this long without this pair of commands.
Use **pushd dir** to stick a directory on the dirs stack and **popd** to take
the last off. Where is this useful? Imagine working in **/var/www/logs**
and now you need to peek over at **/home/user** and while there you pop into
some other directory. Well now **cd -** doesn't work and you're left typing the
full path back to the logs you were reviewing. BUT WAIT! Had you **pushd logs**
you could simply **popd** and be back REGARDLESS of how far you'd traveled.

Very useful magic indeed.
