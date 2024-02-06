---
title: DynamicDNS with CloudFlare
tags: [sysadmin,projects]
date: "09 Sep 2015"
draft: false
slug: "dynamicdns-with-cloudflare"
summary: This blog article describes how to use CloudFlare as a free DDNS provider. The author created a Ruby based DDNS client to modify CloudFlare. The client is called CFDDNS-Ruby and is available on GitHub. The author shares some lessons learned while creating the client, such as not using rest-client and using unirest instead.
---

I've been using [CloudFlare](www.cloudflare.com) for a while now to protect my sites and generally make life easy. If you haven't seen it before then stop here and [go check them out](https://www.cloudflare.com). I'll wait.

If you're already familiar then you know the one of the key requirements is that CloudFlare becomes your DNS provider. They also have a wonderful API. Connect the dots and you too can replace your DDNS provider with a completely free solution, get better security, and accelerate your site! Woo! I decided to build my own Ruby based DDNS client to modify CloudFlare for me. This is partly because I wanted to learn something new and secondly so I can integrate it into all those [Low End Box](http://lowendbox.com/) honeypots I have sprinkled around the web.

Chances are if the server belongs to me it has RVM so this was a pretty simple choice. I simply call the script on a cron schedule, it does the update if needed, and off we go.

Without further blathering I present the final project: [CFDDNS-Ruby](https://github.com/brooksgarrett/cfddns-ruby).

Some lessons learned along the way:

1. Don't use rest-client. Really. Like ever. Simple things like "Hey use this header" devolve into a discussion of "Well which helper are you using? It goes here for this and there for that." Not. Even. Once
2. Use [unirest](http://unirest.io/ruby.html) because great googley moogley it's simple and easy. Try it. You'll like it.