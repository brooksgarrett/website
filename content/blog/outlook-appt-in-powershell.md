---
title: Schedule Outlook Appointments in Powershell
tags: [sysadmin]
date: "30 June 2016"
draft: false
---

Here is a simple script to schedule Outlook appointments from Powershell. I use this to automate reminders to myself during the day...

```powershell
$folder = $outlook.Session.folders |where-object {$_.Name -eq 'email@work.com'}
$cal = $folder.Folders |? {$_.Name -eq "Calendar"}
$appt = $calendar.Items.Add(1)
$appt.Start = [datetime]"06/30/2016 17:00"
$appt.End = [datetime]”06/30/2016 17:30"
$appt.Subject = "Dinner"
$appt.Save()
```

This script demonstrates the basic usage. I'm doing a bit more by saving it as a function in my profile. 