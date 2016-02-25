---
title: HTML5 Input Validation Is Not Sanitization
tags:
- AppSec
- HTML5
date: "07 Oct 2011"
slug: "html5-input-validation-is-not-sanitization"
---
One of the hyped features of HTML5 is the ability to specify the input "type"
of an input on a form as one of several new options:

+ color
+ date
+ datetime
+ datetime-local
+ month
+ week
+ time
+ email
+ number
+ range
+ search
+ tel
+ url

The implementation of this new feature couldn't be easier, simply specify the
"type" attribute of your input field and let the browser handle the rest. For
example, by specifying an input type of "email", Chrome will validate the input
to ensure it is a validly formed email address. In Safari on iOS devices, the
virtual keyboard will automatically change to be more email address friendly
(by adding the @ sign and .com buttons).

All of this functionality comes with no additional scripting by the developer.
For convenience, this is exciting news. User input can now be validated client
side to ensure users are actually putting an email in that field and not a phone
number. For security though, there is absolutely no added benefit. Much as
attackers have been substituting values for years, so they will continue.
The new input types do not prevent an attacker from submitting values of their
choosing via an intercepting proxy.

The old adage still holds true, "If the user can access it, they can abuse it."
Use these new input types for helping good users submit accurate data on the
first attempt, but continue server side data validation and sanitization to
prevent attackers from owning your application.
