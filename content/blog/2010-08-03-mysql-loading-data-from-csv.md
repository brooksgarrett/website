---
title: MySQL - Loading Data from CSV
tags: [infrastructure, mysql]
slug: "mysql-loading-data-from-csv"
date: "03 Aug 2010"
summary: This article explains how to load data from a CSV file into a MySQL table using the LOAD DATA LOCAL INFILE command.
---

I have a 1.86 GB CSV file which I want to put into a table in MySQL. Originally I started by using VIM to modify the source data to add "INSERT INTO ..." statements in front of each line. This approach quickly turned kludgy and took a painfully long time to complete.

Solution? MySQL includes built in support for doing this exact thing. Here is what I did, tailor to your needs:

```
brooks@saosin:~/TrailerPark$ mysql -u root -p
Enter password:

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 153
Server version: 5.1.41-3ubuntu12.3 (Ubuntu)
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

mysql> load data local infile 'NSRLFile.txt' into table file fields terminated by ',' optionally enclosed by '"' lines terminated by '\r\n' (@Vsha1, @Vmd5, @Vcrc, filename, filesize, ProductCode, oscode, specialcode) set sha1 = unhex(@Vsha1),  md5 = unhex(@Vmd5), crc = unhex(@Vcrc);
```

What we are doing is loading the local file NSRLFile.txt. This file is in my present directory, though you could specify an absolute path here as well. Next we tell MySQL to insert the data into the table named file. Now, we tell MySQL how to interpret the data by detailing what the field separator is, how text is enclosed, etc. In my case, the number fields were not enclosed in quote marks so I had to use the OPTIONALLY clause to tell MySQL to pull those fields anyway.

Last, we tell MySQL what fields should map to which columns. In my case, I wanted to dehex (or convert hex to binary) on all hash values. by using the @ symbol, I created three variables named @Vsha1, @Vmd51, and @Vcrc. I used a capital V for readability only, you can use almost any name. To perform the actual conversion, I supplied the variable to the dehex function and used the SET clause to assign that new value to the column I wanted to store the value in.

That's it! Super simple. Feel free to email me with questions...