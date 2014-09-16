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

```yaml
language: ruby
rvm:
  - "2.1.1"
branches:
  only:
    - master
deploy:
  provider: s3
  access_key_id: "$AccessKey"
  secret_access_key: "$SecretKey"
  bucket: "www.brooksgarrett.com"
  endpoint: "www.brooksgarrett.com.s3-website-us-east-1.amazonaws.com"
  region: us-east-1
  local-dir: _site
```

The above YAML specified we are building a ruby project aimed at Ruby version 2.1.1. We will only build and deploy the master branch and then only the _site (default output directory for Jekyll) will be uploaded to my S3 bucket. The endpoint directive is important for Travis to successfully deploy against an S3 website.

Obviously having your S3 credentials in a text file in your repository is silly. Travis provides a command line client as a ruby gem (gem install travis). Once installed you can encrypt sections of your .travis.yml file with:

```bash
travis encrypt --add deploy.secret_access_key
```

```gemfile
# A sample Gemfile
source "https://rubygems.org"

gem 'jekyll', '>=1.4.2'
gem 'nokogiri'
gem 's3_website'
gem 'therubyracer'
gem 'rake'
```

My Gemfile notes that we need Jekyll and all it's required dependencies. You also must have rake listed for Travis to work.

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
