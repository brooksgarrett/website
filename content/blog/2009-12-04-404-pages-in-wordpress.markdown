---
title: 404 Pages in WordPress
tags: [wordpress]
slug: "404-pages-in-wordpress"
date: "04 Dec 2009"
---

If you are receiving a 404 in WordPress, there are 2 possible causes:

1. .htaccess
This file is located in your web root directory. Change the permissions to 666 then modify your PermaLink settings and save them. This will rewrite your .htaccess for you. Be sure to change it back to 440 when done.
1. apached.conf
In the apache config for your web site, make sure AllowOverides is set to All.
