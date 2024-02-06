---

title: WTF time? Give me options!
slug: wtf-time-give-me-options
tags:
- tools
- forensics
date: "08 Feb 2011"
summary: Bash and GNU both have a time command, but they have different options. When using the time command with the -f option to specify the format of the output, you need to use the full path to the GNU time command (/usr/bin/time).
---
I'm looking at the computational cost of computing various hashes. Naturally, I
want to collect run time statistics on each hash command and collect this
metric several thousand times.

The natural choice is to go with time, but I need to use time's format option
to output a CSV output. Sounds easy:

```
brooks@saosin:~$ time -f %e,%S,%U md5sum .viminfo
bash: -f: command not found

real    0m0.002s
user    0m0.000s
sys     0m0.002s
```

WTF? -f is an option, not a command! Come to find out, Bash has its own built-in
 time command which doesn't have the same options as the GNU time command! So
you'll need to use the full path to the GNU utility. If you don't know it, use
which:

```
brooks@saosin:~$ which time
/usr/bin/time
```

Now, let's try this again:

```
brooks@saosin:~$ /usr/bin/time -f %e,%S,%U md5sum .viminfo
0cc07f508925f94b18f50166576b83c7  .viminfo
0.00,0.00,0.00
```

Better!

You can also use -a -o filename to specify where to put that csv output across
multiple runs.