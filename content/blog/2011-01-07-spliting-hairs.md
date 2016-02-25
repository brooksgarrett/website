---
title: Split(ing) Hairs
tags: [posterous]
date: "07 Jan 2011"
slug: splitting-hairs
---
The super timeline often exceeds 65,000 rows and is extremely slow in Excel. To
fix this, split the file into manageable chunks.

_wc -l filename.csv_ gives the number of lines in a file.

_split -l 65000 -d supertimeline.csv supertimeline_ will generate multiple files
 named supertimeline.00 (01, 02, etc) with 65000 lines each. -l is the line
 count and -d tells split to use digits for the prefix instead of letters
 (00 instead of AA). The second supertimeline parameter tells split to use
 supertimeline as the prefex. Omitting the prefix (supertimeline) and -d will
 result in files named xaa, xab, xac, xad, etc.
