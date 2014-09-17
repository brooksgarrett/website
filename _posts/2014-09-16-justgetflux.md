---
layout: post
title: Just Get Flux
categories: [Blog]
tags: [sysadmin]
status: published
type: article
published: true
meta:
  _edit_last: '1'

---

A friend of mine recommended I try out [Flux](https://justgetflux.com) and I'm ever glad I did. The basic premise is that Flux monitors the time of day and adjusts your screen temperature (or hue) to match ambient light levels. The result is a much more enjoyable session at night. I'm sitting in my living room with only a single lamp on and the glow of the light bulb on the keyboard is a near identical match to the color setting suggested by Flux. 

To get it working on my Ubuntu laptop I had to do some magic. First install FluxGUI per the instructions and PPA [here](https://justgetflux.com/linux.html). Next, copy the [64 bit binary](https://justgetflux.com/linux/xflux64.tgz) (a [32 bit](https://justgetflux.com/linux/xflux-pre.tgz) is available as well) and extract. Copy the resulting xflux binary to /usr/bin/xflux (yes, overwrite what is there.)

Now sit back and enjoy the pleasant experience!

