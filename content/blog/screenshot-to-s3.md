---
date: 2016-02-29T11:19:26-05:00
draft: false
title: Screenshot to S3
tags: ["aws", "blog"]
summary: A simple solution for managing images is described. Images are uploaded to S3 using Greenshot, Atom Editor, s3cmd, S3 Browser, and PowerShell. The script is added to Greenshot as an external command. When a screenshot is sent to S3, the script uploads the image with the appropriate name and copies a link to the clipboard.
---

I've been writing in pure [markdown](https://daringfireball.net/projects/markdown/)
for a while and one portion of my workflow still gives me trouble.

Images.

Today I threw together a simple solution for managing images and thought I'd
share in case someone else has issues.

Tools I'm using:

+ [Atom Editor](https://atom.io/)
+ [s3cmd](http://s3tools.org/s3cmd)
+ [S3 Browser](http://s3browser.com/)
+ [Greenshot](http://getgreenshot.org)
+ [Python 2.7](https://www.python.org/downloads/windows/)
+ Custom PowerShell

I publish in Atom. I host in S3. All my rich content (image, video, presentation, etc.)
lives on https://data.brooksgarrett.com/. I'm using S3 Browser to manually upload
images as needed.

What I've changed is using Greenshot for screen capture. Greenshot has a [send
to external command](http://getgreenshot.org/2013/01/28/how-to-use-the-external-command-plugin-to-send-screenshots-to-other-applications/) plugin.
I created a simple PowerShell script to use s3cmd to upload images directly from
Greenshot.

```PowerShell
param (
    [string]$bucket = "s3://data.brooksgarrett.com",
    [string]$prefix = "/uploads/",
    [string]$filename = $( throw "-filename Required" )
 )

if ($bucket.EndsWith("/"))
{
    $bucket=$bucket.Substring(0,$bucket.Length-1)
}

if (!$prefix.StartsWith("/"))
{
    $prefix = "/$prefix"
}

if (!$prefix.EndsWith("/"))
{
    $prefix = "$prefix/"
}

if ($filename.Contains("\"))
{
    $parts = $filename.Split("\")
    $shortfilename = $parts[$parts.Length-1]
}

C:\Python27\python.exe "C:\s3cmd\s3cmd" "put" "$filename" "$bucket$prefix$shortfilename"

"$bucket$prefix$shortfilename".Replace("s3", "https") | clip.exe;
```

Then in Greenshot I simply added the script as an external command:

![Greenshot External Command](https://data.brooksgarrett.com/screenshots/2016_02_29_11_59_18_Configure_command.png)

Anytime I send the screenshot to S3 the PowerShell script will do all the
appropriate naming and copy a link into my clipboard. Woot.