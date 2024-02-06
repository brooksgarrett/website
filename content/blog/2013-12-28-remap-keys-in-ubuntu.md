---
title: Remap Keys in Ubuntu
tags: [technology, howto, linux]
date: "28 Dec 2013"
draft: false
slug: "remap-keys-in-ubuntu"
summary: This article explains how to remap the Caps Lock key to the Escape key in Ubuntu.
---

![A Keyboard](http://data.brooksgarrett.com/images/keyboard.jpg)

I'm following along [Daniel Miessler's Vim Primer](http://www.danielmiessler.com/study/vim/) and saw he remapped the Caps Lock key to be his Control key. I thought this was an interesting concept but I'd rather have Escape on my Caps Lock. Also, I'm running Ubuntu instead of OSX. Off to the interwebs!

A short bit of Google-fu brough me to a [couple](http://askubuntu.com/questions/24916/how-do-i-remap-certain-keys) of [resources](http://wilt.isaac.su/articles/how-to-remap-your-capslock-key-to-esc-key-in-ubuntu-linux) which answered the question for me. Combining the information I found led me to this process for remapping the keys:

1.  Build a clean Xmodmap config

    ```bash
xmodmap -pke >~/.Xmodmap
    ```

1.  Use xev to see what keycode Caps Lock belongs to (Spoilers: It's 66 or 0x42).
1.  Edit the Xmodmap config to remap the Caps Lock Key by editing the following lines:

    ```bash
clear lock
... A bunch of other keycodes ...
keycode  66 = Escape
    ```

1.  Reload the keymap

    ```bash
xmodmap ~/.Xmodmap
    ```

1.  Done

You now have remapped your Escape down to the Caps Lock. One pinky finger closer to total world domination!