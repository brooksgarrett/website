---
date: "18 Aug 2016"
tags: [development, windows, powershell]
draft: false
title: Capturing Session Keys for Wireshark
---

Decrypting HTTPS can be a real pain in Wireshark. I found an article that describes having Chrome 
or FireFox dump Session Keys for you which WireShark can then load and use to decrypt TLS sessions. 
Based on that article I roughed up the below Powershell function so I can selectively dump Session 
keys when I want to and with the browser I choose. By default I use Chrome but by passing an argument 
(2) to the function I can instead switch to Firefox.

```ps
# Intercept Chrome SSL Session Keys
function Intercept-SSLKeys($browser = 1) {
    $env:SSLKEYLOGFILE = "$env:USERPROFILE\ssl_session_keys.txt"

    $burpPath = "";
    $chromePath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe";
    $chromeOpts = ""

    $firefoxPath = "C:\Program Files (x86)\Mozilla Firefox\firefox.exe";
    $firefoxOpts = "-no-remote "

    switch($browser) {
        1 { $browserCmd = $chromePath;
            $browserOpts = $chromeOpts; }
        2 { $browserCmd = $firefoxPath;
            $browserOpts= $firefoxOpts; }
    }

    & $browserCmd $browserOpts

}
```