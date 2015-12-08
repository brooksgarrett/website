---
layout: post
title: "Configuring SDR for Fire Pager Scanning"
date: "2015-12-08 09:59"
categories: [Blog]
tags: [sdr]
status: published
type: article
published: true
---


A boring post on building a SDR scanning machine based on a cheap RTL dongle
and an old emachines computer.

## The Project

I'm a volunteer firefighter and currently our method of receiving pages is...
_outdated_. We carry these black Motorola Minitor pagers which audibly alert
us when we are needed. This works great most of the time. We need some extra
things to happen so I've started looking at how SDR can help us.

My goals are:

1.  Capture _ONLY_ pages meant for my district as an audio file and email/MMS
    that audio to the department.
2.  When a page is received do _things_ at the station:
  1. Turn on the compressor on a timer
  2. Activate some lights
  3. Play audio over the speakers
  4. Send the address to a tablet on the truck

## The Hardware

I'm running XUbuntu 14.04 LTS. The processor is an AMD
Athlon 64 bit with 865 MB of RAM (_wewt_). I'm using a cheap
[RTL based](http://www.banggood.com/E4000-USB-DVB-T-RTL-SDR-Realtek-RTL2832U-R820T-DVB-T-Tuner-Receiver-p-935440.html)
dongle for the RX part of this project. The antenna is a 2 meter J-Pole one of
my fellow firefighters built for HAM use. It's not perfectly tuned but it's
"Good Enough." To interact with the world I'm using a [Phidget 8/8/8 Interface](http://www.phidgets.com/products.php?product_id=1018).

## The Software

I'm using almost all completely Open Source software.

+ RF RX and demodulation: rtl_fm
  + Receives on our pager frequency
  + Squelch noise until signal received
  + Demodulate audio and send to processing script
+ Audio Processing: [TwoToneDetect](http://www.twotonedetect.net/)
+ Audio Plumbing: PulseAudio
+ Real World Interface: Custom Python Script (Phidget)

The whole project is on GitHub.

rtl_fm is a demodulator for multiple FM modes but I'm specifically using the
Narrowband mode since that is what our pagers use.

```sh
rtl_fm -N -f 162.50M -p 60 -o 4 -l 120 | play -t raw -r 24k -e s -b 16 -c 1 -V1 -q -
```

This command will start rtl_fm tuned to our frequency, using Narrowband, with a
correction factor of 60 (since our cheap dongle is... well, cheap), an
oversample of 4x and a squelch of 120. We pipe that through sox so it comes out
via the speakers (which are connected to the station intercom.)

Once everything is coming through the speakers we can use the monitor device in
pulseaudio to pipe that audio back into the listening TwoToneDetect. Oddly, the
only version of TTD I could get working in headless mode with PulseAudio was the
Raspberry Pi version.

TwoToneDetect is able to call a command script once an alert is received. I'm
calling a python script which sends an output lead high and activates the relay
which turns on our air compressor. This way when we arrive at the station the
air brakes on the fire truck are completely charged and ready but we don't have
to leave the compressor on ALL the time (which burns them out far too fast.)
