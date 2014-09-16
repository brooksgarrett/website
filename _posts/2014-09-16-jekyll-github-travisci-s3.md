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
```
My Gemfile notes that we need Jekyll and all it's required dependencies.

