---
title: Local DNS Override for Testing
tags: [sysadmin,linux]
date: "29 Apr 2015"
draft: false
slug: "local-dns-override-for-testing"

---

One of of primary projects involves a local telemetry agent which needs to speak to two separate endpoints. One endpoint is a command channel which provides configuration information while the second is an event channel where the agent sends telemetry and security event data.

Currently we use HAProxy to balance the event channel traffic among several servers. I wanted to move to Amazon Elastic Load Balancing to take advantage of their redundancy and reliability. So now the question is, "How can I test this before we cut all of our customers over?"

I can't control where the agent aims event data (it looks up the DNS name of the event channel from the command channel.)

My first approach was to use DNSMasq and the alias command to simply overwrite the incoming DNS reply with the hardcoded IP of the ELB. This worked for a while but each time the ELB changes its public IP you have to update your configuration and restart DNSMasq. This is because ELB DNS names are really just fast flux A records.

If you want to use the DNSMasq approach simply add a line like this in your DNSMasq file:

```text
# In this example rewrite 54.1.2.3 so the client really
#  receives 10.10.10.10. Update to use IPs as you need.
alias=54.1.2.3,10.10.10.10
```

So instead I decided to find a way to just handle DNS the way I want. I found an excellent Ruby project called [RubyDNS](https://github.com/ioquatix/rubydns). Simply _gem install rubydns_ to get started.

Here is my sanitized Ruby script, also available [on my GitHub](https://github.com/brooksgarrett/dnsstomp).

```ruby
#!/usr/bin/env ruby
require 'rubydns'

INTERFACES = [
    [:udp, "0.0.0.0", 5300],
    [:tcp, "0.0.0.0", 5300]
]
Name = Resolv::DNS::Name
IN = Resolv::DNS::Resource::IN

# Use upstream DNS for name resolution.
UPSTREAM = RubyDNS::Resolver.new([[:udp, "8.8.8.8", 53], [:tcp, "8.8.8.8", 53]])

# Start the RubyDNS server
RubyDNS::run_server(:listen => INTERFACES) do
    match(/the\.current\.dnshost/, IN::A) do |transaction|
        new = UPSTREAM.query("the.cname.i.want.to.test")
        transaction.respond!(new.answer[0][2].address.to_s)
    end

    # Default DNS handler
    otherwise do |transaction|
        transaction.passthrough!(UPSTREAM)
    end
end
```
