---
title: "Git History is Forever"
date: "10 Sep 2015"
tags: [infosec,devlopment]
slug: "git-history-is-forever"
---

There are lots of stories about people accidentally leaking credentials or other sensitive
information via their Git repositories. It never fails that someone is working on their
early project and hardcodes an API key. Then they commit that key and the leak is on.

It's important to understand how Git works and what you should do if this happens to you.
First understand that Git is effectively a log that will forever remember all your commits
and changes even long after you wish it wouldn't.

As an example here is a tale of two repositories.

### Repository: Test

First we create a new repositoy called "test". For our very first commit we create a *good_file*
which has some funny cats and a *bad_file* which has our API key. Oops.

```bash
brooks@box-of-shame:~/Code$ git init test
Initialized empty Git repository in /home/brooks/Code/test/.git/
brooks@box-of-shame:~/Code$ cd test/
brooks@box-of-shame:~/Code/test$ touch good_file
brooks@box-of-shame:~/Code/test$ touch bad_file
brooks@box-of-shame:~/Code/test$ echo My API password > bad_file
brooks@box-of-shame:~/Code/test$ echo Funny cats > good_file
brooks@box-of-shame:~/Code/test$ git add .
brooks@box-of-shame:~/Code/test$ git status
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

	new file:   bad_file
	new file:   good_file

brooks@box-of-shame:~/Code/test$ git commit
[master (root-commit) 35d2488] First commit
 2 files changed, 2 insertions(+)
 create mode 100644 bad_file
 create mode 100644 good_file
```

Let's make a new *.gitignore* file so this never happens again. Also, we should remove that
pesky *bad_file* from our existing repository.

```bash
brooks@box-of-shame:~/Code/test$ vi .gitignore
brooks@box-of-shame:~/Code/test$ git rm -r --cached .
rm 'bad_file'
rm 'good_file'
brooks@box-of-shame:~/Code/test$ ls
bad_file  good_file
brooks@box-of-shame:~/Code/test$ git add .
brooks@box-of-shame:~/Code/test$ ls
bad_file  good_file
brooks@box-of-shame:~/Code/test$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	new file:   .gitignore
	deleted:    bad_file

brooks@box-of-shame:~/Code/test$ git commit -m 'No more secrets'
[master 3572a25] No more secrets
 2 files changed, 2 insertions(+), 1 deletion(-)
 create mode 100644 .gitignore
 delete mode 100644 bad_file
brooks@box-of-shame:~/Code/test$ git status
On branch master
nothing to commit, working directory clean
brooks@box-of-shame:~/Code/test$ ls
bad_file  good_file
```

Wahoo! It's gone! Now when someone clones my repository that *bad_file* shouldn't
exist.

### Repository: Test2

Now we clone that repository and behold that *bad_file* is indeed gone.

```bash
brooks@box-of-shame:~/Code$ git clone test/.git test2
Cloning into 'test2'...
done.
brooks@box-of-shame:~/Code$ cd test2
brooks@box-of-shame:~/Code/test2$ ls
good_file
```

I think we're OK! Until you remember that Git is a series of commits stored as a
running log. One of the key virtues of Git is we can go back to *any* commit. This
is a great feature for when you introduce a new bug and want to revert or simply
pinpoint when the bug was introduced. By viewing the log we can get the commit
hash and restore our file system back to *any* previous commit.

```bash
brooks@box-of-shame:~/Code/test2$ git log
commit 3572a25eb0b13e93feb69f03b63bb059b24969af
Author: Brooks Garrett <brooks+git@brooksgarrett.com>
Date:   Thu Sep 10 10:19:01 2015 -0400

    No more secrets

commit 35d2488d1571682284db121c1eb1907bcec1b26e
Author: Brooks Garrett <brooks+git@brooksgarrett.com>
Date:   Thu Sep 10 10:17:18 2015 -0400

    First commit
brooks@box-of-shame:~/Code/test2$ git checkout 35d2488d1571682284db121c1eb1907bcec1b26e
Note: checking out '35d2488d1571682284db121c1eb1907bcec1b26e'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b new_branch_name

HEAD is now at 35d2488... First commit
brooks@box-of-shame:~/Code/test2$ ls
bad_file  good_file
brooks@box-of-shame:~/Code/test2$ cat bad_file
My API password
brooks@box-of-shame:~/Code/test2$
```

Thus despite our efforts the private key is STILL THERE! So what can we do?

### Fix it

GitHub obviously sees this pretty often and has a great
[article](https://help.github.com/articles/remove-sensitive-data/) on how to
handle this situation.

> Step 1: CHANGE THE PASSWORD. NOW.

No seriously. Stop reading this if you haven't already changed whatever it was
you leaked. It's already compromised. People already have it. #GameOver. Even
after we fix your history up there can still be other copies (forks, etc) that
won't be revised. You are only fixing your local copy and the remote repository.

What we are going to do is run a search and purge this file wherever it lives.

```bash
brooks@box-of-shame:~/Code/test$ git log
commit 3572a25eb0b13e93feb69f03b63bb059b24969af
Author: Brooks Garrett <brooks+git@brooksgarrett.com>
Date:   Thu Sep 10 10:19:01 2015 -0400

    No more secrets

commit 35d2488d1571682284db121c1eb1907bcec1b26e
Author: Brooks Garrett <brooks+git@brooksgarrett.com>
Date:   Thu Sep 10 10:17:18 2015 -0400

    First commit
brooks@box-of-shame:~/Code/test$ git filter-branch --force --index-filter \
> 'git rm --cached --ignore-unmatch bad_file' \
> --prune-empty --tag-name-filter cat -- --all
Rewrite 35d2488d1571682284db121c1eb1907bcec1b26e (1/2)rm 'bad_file'
Rewrite 3572a25eb0b13e93feb69f03b63bb059b24969af (2/2)
Ref 'refs/heads/master' was rewritten
brooks@box-of-shame:~/Code/test$ git status
On branch master
nothing to commit, working directory clean
brooks@box-of-shame:~/Code/test$ git log
commit eefb6b71ae816f5619395da4fac3166929cefa6e
Author: Brooks Garrett <brooks+git@brooksgarrett.com>
Date:   Thu Sep 10 10:19:01 2015 -0400

    No more secrets

commit fdfc992b2ac52ace9619d637f5e6a76af11310bc
Author: Brooks Garrett <brooks+git@brooksgarrett.com>
Date:   Thu Sep 10 10:17:18 2015 -0400

    First commit
```

That *Rewrite* stuff looks wonderful! If we take a look at the specific commit
we can verify the *bad_file* is gone.

```bash
brooks@box-of-shame:~/Code/test$ git show fdfc992b2ac52ace9619d637f5e6a76af11310bc
commit fdfc992b2ac52ace9619d637f5e6a76af11310bc
Author: Brooks Garrett <brooks+git@brooksgarrett.com>
Date:   Thu Sep 10 10:17:18 2015 -0400

    First commit

diff --git a/good_file b/good_file
new file mode 100644
index 0000000..5d54098
--- /dev/null
+++ b/good_file
@@ -0,0 +1 @@
+Funny cats
```

Now we have to push (with a helpful --force) this repo out to the remote repo.
Then when someone clones the repo again our file will not be present!

```bash
brooks@box-of-shame:~/Code$ git clone test/.git test_good
Cloning into 'test_good'...
done.
brooks@box-of-shame:~/Code$ cd test_good/
brooks@box-of-shame:~/Code/test_good$ ls
good_file
brooks@box-of-shame:~/Code/test_good$ git log
commit eefb6b71ae816f5619395da4fac3166929cefa6e
Author: Brooks Garrett <brooks+git@brooksgarrett.com>
Date:   Thu Sep 10 10:19:01 2015 -0400

    No more secrets

commit fdfc992b2ac52ace9619d637f5e6a76af11310bc
Author: Brooks Garrett <brooks+git@brooksgarrett.com>
Date:   Thu Sep 10 10:17:18 2015 -0400

    First commit
brooks@box-of-shame:~/Code/test_good$ git checkout fdfc992b2ac52ace9619d637f5e6a76af11310bc
Note: checking out 'fdfc992b2ac52ace9619d637f5e6a76af11310bc'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b new_branch_name

HEAD is now at fdfc992... First commit
brooks@box-of-shame:~/Code/test_good$ ls -la
total 16
drwxrwxr-x 3 brooks brooks 4096 Sep 10 11:08 .
drwxrwxr-x 9 brooks brooks 4096 Sep 10 11:08 ..
drwxrwxr-x 8 brooks brooks 4096 Sep 10 11:08 .git
-rw-rw-r-- 1 brooks brooks   11 Sep 10 11:08 good_file
```

Praise be to our Git overlords! Now let us all say it together:

> I will not commit secret things.
