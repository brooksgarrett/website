---
title: MySQL and Indexes
tags: [mysql, sysadmin, infrastructure]
slug: "mysql-and-indexes"
date: "03 Aug 2010"
---
So what happens when you have over 1 million rows in a table and you try to do a lookup?

```mysql
mysql> describe file;
+-------------+----------------------+------+-----+---------+-------+
| Field       | Type                 | Null | Key | Default | Extra |
+-------------+----------------------+------+-----+---------+-------+
| sha1        | binary(20)           | NO   |     | NULL    |       |
| md5         | binary(16)           | NO   |     | NULL    |       |
| crc         | binary(4)            | NO   |     | NULL    |       |
| filename    | varchar(150)         | YES  |     | NULL    |       |
| filesize    | int(11)              | YES  |     | NULL    |       |
| ProductCode | smallint(5) unsigned | YES  |     | NULL    |       |
| oscode      | varchar(15)          | YES  |     | NULL    |       |
| specialcode | varchar(15)          | YES  |     | NULL    |       |
+-------------+----------------------+------+-----+---------+-------+
8 rows in set (0.00 sec)

mysql> select hex(sha1), filename, productcode, oscode from file
-> where sha1 = dehex('C00002DED6E03A93513D4EA144486B2E33A3AC83');
ERROR 1305 (42000): FUNCTION nsrl.dehex does not exist
mysql> select hex(sha1), filename, productcode, oscode from file where sha1 = un                                                                             hex('C00002DED6E03A93513D4EA144486B2E33A3AC83');
+------------------------------------------+-------------+-------------+---------+
| hex(sha1)                                | filename    | productcode | oscode  |
+------------------------------------------+-------------+-------------+---------+
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        2584 | WIN     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |       15322 | 358     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        2912 | WIN     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        3164 | WIN     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        3192 | WIN     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        4925 | WIN     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        4943 | WIN     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        5604 | Unix3.5 |
+------------------------------------------+-------------+-------------+---------+
8 rows in set (1 min 47.92 sec)
```

LOOK AT THAT RUNTIME! Add indexes stupid.

```mysql
mysql> alter table file add index (sha1), add index (md5);

mysql> alter table file add index (sha1), add index (md5);
mysql> select hex(sha1), filename, productcode, oscode from file where sha1 = unhex('C00002DED6E03A93513D4EA144486B2E33A3AC83');
+------------------------------------------+-------------+-------------+---------+
| hex(sha1)                                | filename    | productcode | oscode  |
+------------------------------------------+-------------+-------------+---------+
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        2584 | WIN     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |       15322 | 358     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        2912 | WIN     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        3164 | WIN     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        3192 | WIN     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        4925 | WIN     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        4943 | WIN     |
| C00002DED6E03A93513D4EA144486B2E33A3AC83 | hticons.dll |        5604 | Unix3.5 |
+------------------------------------------+-------------+-------------+---------+
8 rows in set (0.00 sec)
```

Indexing. It works ;-)
