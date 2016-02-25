---
title: My Experience with Chef, Redux
tags: [sysadmin]
date: "08 Aug 2013"
draft: false
slug: "my-experience-with-chef-redux"
---

[Chef] (http://opscode.com "Chef") isn't SO horrible. Here is the running list of things I've done to get it working from a client perspective.

### Installing Gems
If you use the omnibus installer (from the opscode site as opposed to apt/yum) you can't just use Gem to install things. There seems to be a disconnect between the ruby runtime the knife command uses and the gems repository your system normally uses. Instead, you need to use the embedded gem command as follows (this example demonstrates installing the knife-ec2 gem):

> sudo /opt/chef/embedded/bin/gem install knife-ec2

### Getting knife.rb Right
Here is my knife.rb for Amazon AWS:

```
log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               '/home/ubuntu/.chef/admin.pem'
validation_client_name   'chef-validator'
validation_key           '/home/ubuntu/.chef/chef-validator.pem'
chef_server_url          'https://REDACTED.compute-1.amazonaws.com'
syntax_check_cache_path  '/home/ubuntu/.chef/syntax_check_cache'
cookbook_path ["~/chef-repo/cookbooks"]
cookbook_copyright "REDACTED"
cookbook_email     "REDACTED@REDACTED.com"
cookbook_license   "none"

knife[:aws_ssh_key_id] = 'REDACTED-chef'
knife[:availability_zone]     = 'us-east-1b'
knife[:region]                = 'us-east-1'
knife[:aws_access_key_id]     = 'REDACTED'
knife[:aws_secret_access_key] = 'REDACTED'
```
