---
title: Remote Streaming with Pi and MPD
tags: [linux,sysadmin,streaming]
date: "22 Mar 2015"
draft: false
slug: "remote-streaming-with-pi-and-mpd"
---

I wanted to be able to stream Spotify on my outdoor system without resorting to Bluetooth and streaming from my phone. I still had my original Raspberry Pi Model B around so I started looking for a way to run Spotify on the command line. That gave way to the [Mopidy](https://www.mopidy.com/) project. Getting it running on the Pi is [fairly well documented](https://docs.mopidy.com/en/latest/installation/raspberrypi/). I noticed a step or two missing so below I placed my exact steps to get up and running on my Pi.

This was my procedure on Raspbian 7.

1. Update your Pi firmware (This is *crucial*).

  ```sh
sudo rpi-update
  ```

1. Update Raspbian

  ```sh
sudo apt-get update
  ```

1. Add the Mopidy repository and install

  ```sh
wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
sudo cat <<EOF > /etc/apt/sources.list.d/mopidy.list
# Mopidy APT archive
deb http://apt.mopidy.com/ stable main contrib non-free
deb-src http://apt.mopidy.com/ stable main contrib non-free
EOF
sudo apt-get update
# This will install the Spotify plugin
sudo apt-get install mopidy mopidy-spotify
  ```

1. I had HDMI connected so I had to set audio output to Analog. There are other approaches here but this *just works.*

  ```sh
sudo amixer cset numid=3 1
  ```

1. Last, here is my config for Mopidy

  ```text
[logging]
config_file = /etc/mopidy/logging.conf
debug_file = /var/log/mopidy/mopidy-debug.log

[local]
enabled = true
data_dir = /var/lib/mopidy/local
media_dir = /var/lib/mopidy/media
playlists_dir = /var/lib/mopidy/playlists

[spotify]
username = "My Spotify Username"
password = "My Spotify Password"

[audio]
mixer = software
output = autoaudiosink

[mpd]
enabled = true
hostname = "IP Address"
port = 6600
password = music
  ```

Now [install your favorite client](http://mpd.wikia.com/wiki/Clients). I'm using MPDroid and really really happy with it.
