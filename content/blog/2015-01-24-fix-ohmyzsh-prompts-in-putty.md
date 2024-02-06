---
title: Fix OhMyZSH Prompts in PuTTY
tags: [linux, windows, sysadmin]
date: "24 Jan 2015"
draft: false
slug: "fix-ohmyzsh-prompts-in-putty"
summary: This article provides a solution to fix the issue of OhMyZSH prompts appearing as strange alphanumeric representations in PuTTY. The solution involves changing the translation setting to UTF-8 and installing a specific font called Meslo Font.
---

Part of the draw to oh-my-zsh and zsh in general is the tight git integration. While I'm working on the console I see this:

```bash
➜  _posts git:(master) ✗
```

This is awesome. The arrow tells me my last command returned an exit code 0 (since it is green), I know I'm in my posts directory, I'm on the master branch, and I have unstaged/uncommitted changes. That's *way* more useful than knowing I'm on a server as a certain user!

The problem starts when you use putty. Those nice clean icons turn into really strange looking alphanumeric representations. The fix is easy.

First, change the translation setting to UTF-8. This is found under the Window->Behavior section. By default it is ISO-8859-1:1998 (Latin-1, West Europe) on my machine. This one setting will help but the glyphs were still odd looking. The arrow was partially filled and the 'x' was grainy.

I found an [issue submission](https://github.com/robbyrussell/oh-my-zsh/issues/1310) detailing a font that helps make the console more asthetically pleasing. You can download and install it by visiting  [andreberg's GitHub](https://github.com/andreberg/Meslo-Font/downloads).

Once you install the font on your system you'll need to update your saved settings by changing the font under Window->Appearance.