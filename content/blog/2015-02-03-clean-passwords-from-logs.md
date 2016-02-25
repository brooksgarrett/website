---
title: Clean Passwords from Logs
tags: [sysadmin, linux]
date: "03 Feb 2015"
draft: false
slug: "clean-passwords-from-logs"
---

Today was a day of fixing things. We had some issues with a bad behaving Storm topology so I wrote up some scripts to automate collecting the heap dump, generating a report, tailing relevant logs, and then shipping the whole thing off to a file server. Worked great until I realized the developers were keeping sensitive information in the topology config which is spewed into the log on every restart!

Enter sed. I needed to purge out any connection strings for our databases which I accomplished with the following commands:

```bash
sed -r 's/(vertica|secondarydb)\.([^"]+)" "?[^,]+/\1.\2" "*****"/g'
```

What it does:

+  Use extended regex (Breaks portability in favor of using GNU extensions)
+  Perform a substitute operation
+  Find the word _vertica_ or _secondarydb_ followed by a literal dot, a space, and then a double quoted string
+  Replace whatever you found with _vertica_ or _secondarydb_, a literal dot, whatever came after the previous word, and a
masked representation of the sensitive info
