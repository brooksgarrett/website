---
title: Cordova Browser Platform Support on Linux
tags: [mobile]
date: "29 Dec 2014"
draft: false
slug: "cordova-browser-on-linux"
---

I'm working on a new mobile application which, of course, means [Cordova](http://cordova.apache.org/). Recently Cordova added the "browser" platform so you can test your application right on the desktop with no hackery required.

Getting the platform added to your project and run it as a browser app is as simple as:

```bash
cordova platform add browser
cordova run browser
```

I, however, am on Linux and when I first tried to run on the browser platform I only got a blank output with no browser. Lame sauce. The solution is to patch the script used by Cordova to launch the browser.

```js
  case 'linux':
    spawn('/usr/bin/google-chrome',['-n', '-a', '--args', '--disable-web-security', '--user-data-dir=/tmp/temp_chrome_user_data_dir_for_cordova_browser', project] );
    break;
```

Make sure to modify the path to Chrome if needed.

_UPDATE_: I've since discovered you can pull an updated script from [Cordova's GitHub](https://github.com/apache/cordova-browser/blob/master/bin/templates/project/cordova/run).
