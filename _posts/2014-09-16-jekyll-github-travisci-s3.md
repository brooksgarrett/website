---
layout: post
title: Static Site with Jekyll, GitHub, TravisCI, and S3
categories: [Blog]
tags: [sysadmin]
status: published
type: article
published: true
meta:
  _edit_last: '1'

---

For a while now I've been exclusively using [Jekyll][jekyll] to publish my site. At first I started with basic [Jekyll][jekyll] running on [DigitalOcean][do]. This worked well but meant I needed to SSH to a server when I wanted to post content. Not _really_ the best requirement for a seamless workflow but it worked for a while. Then I started using Git and GitHub to manage the content as a repository. A bit of php later and I had a post-commit hook in GitHub to notify the [DigitalOcean][do] server that new content was ready. This was better but broke all the time for random reasons. 

Next I decided to just kill the [DigitalOcean][do] server completely and use s3\_website to push content up to an S3 bucket hosted site. Yet another improvement but still not completely there. 

Finally I think I'm close. Currently I write comment in markdown (so I can focus on content, not format) which is parsed and published by [Jekyll][jekyll]. The content is versioned and managed by Git, hosted on GitHub (feel free to PR spelling and grammar issues), and finally published by [Travis-CI][travis] to S3. Now my workflow essentially consists of 

>  Create content

It's that easy. I have vim hooks to add, commit, and push content as I create it. Once pushed to GitHub then [Travis-CI][travis] picks up the commit, builds it, and deploys to S3. Oh, and if something breaks along the way I either get an immediate error or [Travis-CI][travis] emails me to let me know. Maybe this isn't perfect but it's ever so much closer to it.

Here's how you can do it too.

First get a [Travis-CI][travis] account and a GitHub if you don't already have them. It's probably a good idea to have those things anyway.

First you need a .travis.yml file which tells Travis how to build and deploy the repository.

```yaml
language: ruby
rvm:
  - "2.1.1"
branches:
  only:
    - master
deploy:
  provider: s3
  no_cleanup: true
  access_key_id: "$AccessKey"
  secret_access_key: "$SecretKey"
  bucket: "www.brooksgarrett.com"
  endpoint: "www.brooksgarrett.com.s3-website-us-east-1.amazonaws.com"
  region: us-east-1
  local-dir: _site
```

The above YAML specified we are building a ruby project aimed at Ruby version 2.1.1. We will only build and deploy the master branch and then only the \_site (default output directory for [Jekyll][jekyll]) will be uploaded to my S3 bucket. The endpoint directive is important for Travis to successfully deploy against an S3 website. It is critical you have the no\_cleanup line or the S3 deploy will fail.

Obviously having your S3 credentials in a text file in your repository is silly. Travis provides a command line client as a ruby gem (gem install travis). Once installed you can encrypt sections of your .travis.yml file with:

```bash
travis encrypt --add deploy.secret_access_key
```
Next you need a clean Gemfile. The more bloated the Gemfile is the slower your deploy will be (as [Travis-CI][travis] downloads and configures all the Gems.) As is I'm able to deploy in around 1-2 minutes which isn't terrible.

```gemfile
# A sample Gemfile
source "https://rubygems.org"

gem 'jekyll', '>=1.4.2'
gem 'nokogiri'
gem 's3_website'
gem 'therubyracer'
gem 'rake'
```

My Gemfile notes that we need [Jekyll][jekyll] and all it's required dependencies. You also must have rake listed for Travis to work.

Now you need a Rakefile so [Travis-CI][travis] can build the project.

```yaml
desc "clean"
task :clean do
  rm_rf '_site'
  FileList['**/*.bak'].clear_exclude.each do |f|
    rm_f f
  end
end

desc "build the site"
task :build do
  sh "bundle exec jekyll build"
end

desc "rebuild, then deploy to remote"
task :deploy => [ :clean, :build ] do
  sh "bundle exec s3_website push"
end

desc "Default task is to clean and build"
task :default => [ :clean, :build ]
  puts "Task complete"
end
```

My Rakefile contains tasks for cleaning up old artifacts, building the site, and deploying the site via s3_website for local testing. Travis calls the :default task by, well, default so I have configured that task to be only a clean and build. This lets Travis handle the deploy independently.
