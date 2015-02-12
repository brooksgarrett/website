---
layout: post
title: Nagios SMS Alerts with Amazon SNS
categories: [Blog]
tags: [sysadmin,linux]
status: published
type: article
published: true
meta:
  _edit_last: '1'

---

Nagios is the stalwart go-to system monitoring solution that won't die. Despite a bevy of replacement solutions and huge set of commercial offerings the little open source project that could keeps our infrastructure running. One of the key components of Nagios is alerting when something breaks. Today I integrated our Nagios deployment with Amazon Simple Notification Service to deliver SMS messages to our engineers.

## Configuring SNS
First, be aware that currently ONLY US East 1 supports SMS messaging. That means you need to follow along using the N. Virginia region. The good news is you can publish to the SNS service from anywhere (so your servers in Oregon or even in your private datacenter will still work.)

Create a topic in SNS by choosing "Create a Topic". Give the Topic a name which is used in your scripts and also a Display Name. The Display Name is required to configure SMS on the topic. Also, the Display name will be the first part of every SMS message the service sends. Last, keep in mind that you have to configure recipients on a per topic basis so if you have 100 users and 10 topics that's 1000 mouse clicks. Be careful to fragment as much as needed but no more.

Once you create the topic copy the Topic ARN to a notepad file for use later.

## Configuring API Keys
Now go to IAM and create a user generating a new access key for the user as you do so. Copy the credentials to your notepad file. Once you close this page you won't be able to see them again.

Now click your user and expand the "Inline Policy" section. We are going to grant the user the ability to Publish events to the topic we created earlier.

Choose "Policy Generator."

Under AWS service choose Amazon SNS. Under "Actions" choose "List Topics." For Amazon Resource Name enter "*". Click "Add Statement."

Under AWS service choose Amazon SNS. Under "Actions" choose "Publish." Last, put the Topic ARN we copied earlier in the Amazon Resource Name box. Click "Add Statement."

Click "Next Step."

Apply your policy. Your user can now publish to the SNS topic.

## Configuring Nagios

Grab the python script from [https://github.com/sricola/pyAmazonSNS](https://github.com/sricola/pyAmazonSNS). I placed mine in "/opt/pyAmazonSNS/send_sns.py".

You'll need to update the credentials on line 69:

```python
    sns = boto.connect_sns("AWS_ACCESS_KEY_ID","AWS_SECRET_ACCESS_KEY", region=region)
```

Next add the commands to your Nagios configuration:

```text
# 'notify-host-by-sns' command definition
define command{
        command_name    notify-host-by-sns
        command_line    /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\nHost: $HOSTNAME$\nState: $HOSTSTATE$\nAddress: $HOSTADDRESS$\nInfo: $HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | /opt/pyAmazonSNS/send_sns.py --topic="TOPIC_NAME" --sub="$NOTIFICATIONTYPE$ Host Alert: $HOSTNAME$ is $HOSTSTATE$"
        }

# 'notify-service-by-sns' command definition
define command{
        command_name    notify-service-by-sns
        command_line    /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\n\nService: $SERVICEDESC$\nHost: $HOSTALIAS$\nAddress: $HOSTADDRESS$\nState: $SERVICESTATE$\n\nDate/Time: $LONGDATETIME$\n\nAdditional Info:\n\n$SERVICEOUTPUT$\n" | /opt/pyAmazonSNS/send_sns.py --topic="TOPIC_NAME" --sub="$NOTIFICATIONTYPE$ Service Alert: $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$"
        }
```

A couple of things to note. First, you need to set the TOPIC_NAME to your topic name (not the "Display Name".) Second, the "--sub" argument is what will be sent to SMS users. This is due to the way Amazon SNS works. The message portion (everything before the "|") will go out to other subscribers including anyone subscribing by email. This is both a blessing and a curse in that it's poorly documented but means you can notify once and reach people by any supported subscription method (web hooks, email, SMS, SQS, etc).

Last update your contacts to use this command as the notification method when needed. After that reload your config and enjoy being woken up by SMS at 4AM!
