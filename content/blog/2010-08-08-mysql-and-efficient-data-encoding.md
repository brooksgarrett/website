---
title: MySQL and Efficient Data Encoding
tags: [mysql, sysadmin]
date: "08 Aug 2010"
slug: "mysql-and-efficient-data-encoding"
---
As I've been working to expose the National Software Reference List via a new webservice, I've had to find ways to store data efficiently to avoid nuking my server. One of the biggest issues was the shear size of the database.

Each file record has 2 hashes, a SHA-1 and a MD5 hex-encoded value. Currently, there are 58,272,836 files hashed as part of the NSRL effort. This means 58,272,836 rows of data and 116,545,672 hash values.

So, let's do some quick math. An MD5 hash is 32 Hexadecimal characters which is 32 bytes of data. SHA-1 is represented by 40 Hexadecimal characters which means 40 bytes of data. So combined, a string representation of the hashes will require 72 bytes for every row. Some quick math gives us the space requirements <em>just</em> the hashes!

+ 72B * 58,272,836 Records = 4,195,644,192 Bytes = 4.2 GB<

That means nearly 4.2GB of storage JUST FOR THE HASHES!!! The solution lies in understanding what the hash actually represents and further, how MySQL can store that value. A hash is represented by a Hex string, but that is just a representation of an underlying number. That means we can store the hash as an INT or similar raw number, but we can shrink our requirements even more by storing the hash as a binary value. MySQL even provides a native method [hex() unhex()] for converting between a HEX string and binary.

By storing the hash as a binary object, we realize IMMENSE space savings. Warning: More Math! A SHA-1 hash is 160 bits while a MD5 hash is 128 bits. All told, that is 288 bits per row where previously we were using 576 bits.

+ 288 bits / 576 bits = 50% Savings</li>
+ 36 B * 58,272,836 Records = 2,097,822,096 B = 2.1GB</li>

And there you have it, we reduced our storage utilization by 50% down to 2.1GB. Now that's efficient!
