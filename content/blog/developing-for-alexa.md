---
title: Developing for Alexa
tags: [tech, dev, alexa]
date: "04 Jan 2017"
draft: false
slug: "developing-for-alexa"
summary: Developing a custom skill for Alexa from zero to production took about 6 hours, including learning AWS Lambda, IAM policies, and Travis-CI setup. Key lessons learned: use a short invocation, account for Alexa's phonetic input, and test thoroughly.
---

For my first [1 Project Per Month Challenge](https://medium.com/1ppm/the-1ppm-challenge-eaed5df0ef5a#.2hyi8yhfy) I 
took a previous idea and ported it so I can retreive information from our new Echo Dot. 
[There](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/alexa-skill-tutorial) 
[are](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/getting-started-guide) 
[guides](https://hackernoon.com/my-first-alexa-custom-skill-6a198d385c84#.mo1vmceu3) on
building your first Alexa skill so I'll only cover the unique things I stumbled on while developing my first skill.

The goal is to create a skill for Alexa that will retreive the Fire Danger Class for a nearby tower. This information is
most useful for people who:

1.  May want to burn yard debris that day
1.  Are Fire/Rescue personnel wondering if burning is prohibited that day
1.  Like random data

Obviously my desires are mostly in the second role. 

### Lesson One) Invocation is Important

With Alexa you are developing for a voice interface and it's an odd experience. At the core, Alexa uses "invocations" 
to determine which "skill" you are attempting to leverage. My first draft was to use "Georgia Fire Weather Conditions"
to activate the skill. So you would need to ask,

  "Alexa, ask Georgia Fire Weather Conditions for the fire danger class in Adel today."

That's a mouthful. I've shortened it to "Fire Weather". Getting a short invocation is pretty important and I can't help
but wonder if short invocations will become the next Domain War.

### Lesson Two) Alexa isn't Perfect

The next issue came about once I actually started testing the voice interface. 
[Adel, GA](https://en.wikipedia.org/wiki/Adel,_Georgia) is a small town in South Georgia that also houses a fire watch
tower for Georgia Forestry. Being close to my home town I asked Alexa about the fire report for "Adel." Alexa 
interpreted that command as "A dell." My initial script simply took whatever input it got from Alexa, searched the 
GA Forestry page for that station, and returned the results. There is no "Dell" on the page. I tried multiple solutions
and finally settled on [fuzzyset.js](http://glench.github.io/fuzzyset.js/) which was able to match up Alexa spellings 
with the correct city 99% of the time. This is something I hadn't accounted for at all in the initial design nor in 
testing. The key is understanding that Alexa will provide phonetically equivalent inputs and your app needs to accounted
for matching that to the correct data.

### Summary

Overall developing a Custom Skill for Alexa from zero to production took about 6 hours. This included learning to use 
AWS Lambda, setting up IAM policies, and configuring Travis-CI for build and deploy. It's remarkably easy to do and I 
look forward to adding other custom skills in the future!