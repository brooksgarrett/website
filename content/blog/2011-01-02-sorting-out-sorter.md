---
title: Sorting out Sorter
tags: [forensics, volume analysis]
date: "02 Jan 2011"
slug: sorting-out-sorter
---
Brian Carrier has provided the forensics community with tools that are absolutely vital to open source forensics. One
tool I tend to under utilize is sorter. Sorter is used to 'sort' files in an image into categories using file headers
as the primary resource. Thus the output is a set of text files ("images.txt", ""archive.txt", etc.) which details
what the files are. This can greatly reduce investigation time if you know what you are looking for (Images? 
Sensitive documents? Emails?)

Sorter also has the ability to leverage the NSRL (National Software Reference Library) to sort files with known hashes
into an "Exclude" category thus eliminating them from the review process and reducing investigation time. As the NSRL
is provided (free of charge) by NIST, this process of removing known files from the analysis procedure is colloquially
referred to as "De-NISTing." the investigator can also use custom hash databases to either alert when a file matches (-a)
or exclude and ignore a file when it matches (-x). You can use all three options together (NIST NSRL, alert hash database,
and exclude hash database).

To make my exclude database, I obtain a freshly deployed machine from our desktop or server teams. I bring the drive into
my forensics workstation and mount the drive ro with an attached hardware write-block in place.

NOTE: Though you don't need a forensically sound image for this process, it never hurts to practice your skills and maintain good
habits.

Use MD5Deep to generate a hash list.

```
md5deep -klr /path/to/mountpoint &gt; ignore_hashes
```

This will generate your list of known files which can be safely ignored. For my alert hashes, I often create a list of hashes of
various pieces of malware.

Once the hash lists (often referred to as your hash databases) are ready, they need to be indexed before sorter can use them. Use
hfind  to index the hash databases.

```
hfind -i md5 ignore_hases
```

The -i tells hdfind that the file it is indexing contains md5 hashes. This command will output a .idx file in the current directory
which sorter will use. For sorter to find and use the index it **must be in the same directory as the hash database it indexes.**

That's it for now. With this information, you are ready to go De-NIST!
