---
title: HTML5 Input Validation Is Not Sanitization
tags:
- AppSec
- HTML5
date: "07 Oct 2011"
slug: "html5-input-validation-is-not-sanitization"
summary: HTML5 input types offer client-side validation, but attackers can bypass this validation and submit malicious input. Server-side data validation and sanitization remain essential for security.
---
One of the hyped features of HTML5 is the ability to specify the input "type" of an input on a form as one of several new options. This provides client-side validation, ensuring users enter valid data. However, this validation does not prevent attackers from submitting malicious input. Server-side data validation and sanitization are still necessary to protect against attacks.