---
layout: post
title: My Experience with Chef
categories:
- Blog
tags: [syasdmin]
status: publish
type: post
published: true
meta:
  _edit_last: '1'

---

[Chef] (http://opscode.com "Chef") is an automation platform that is supposed to make your life easier. Well if you can get it to install. Oh, and run. And don't forget to learn its special syntax which is based on Ruby. So maybe learn some Ruby. AND do try to remember that while Windows is supported, it's still pretty much just an interface into PowerShell.

I've spent weeks fighting with Chef. First trying to install it. The latest doesn't play well with Ubuntu leading to all sorts of issues which you can resolve with a few hours of research. I thought to try an Amazon AWS build as well only to find that ignoring the fact their bug tracker has had a fix since May, OpsCode still hasn't updated the configuration scripts with the two line update to make it work with Amazon Linux.

That's OK though because I found the [article] (http://tickets.opscode.com/browse/CHEF-3838?focusedCommentId=34297&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-34297) and implemented the fix. Which is GREAT because now my server works but the default credentials don't. Except really they DO except I get this lame error:
>  Could not complete logging in.

Thanks. VERY informative. All in all I think I'd rather just build my servers by hand. Scratch that, I'd rather build servers by hand with a floppy disk than deal with this. /rant
