---
date: "26 Jul 2016"
tags: [compliance, nist]
draft: false
title: NIST Deprecates SMS 2FA
---

While you were sleeping, NIST has released their latest public draft of 
[SP 800-63 on GitHub](https://github.com/usnistgov/800-63-3/blob/nist-pages/sp800-63a/cover.md#sec5).

Among the changes is this comment regarding SMS messages as an Out of Band (OOB) 
token for 2 Factor Authentication. 

From [SP 800-63B Section 5.1.3.2](https://github.com/usnistgov/800-63-3/blob/nist-pages/sp800-63b/sec5_authenticators.md)

>  Due to the risk that SMS messages may be intercepted or redirected, implementers of new systems SHOULD carefully 
>  consider alternative authenticators. If the out of band verification is to be made using a SMS message on a public 
>  mobile telephone network, the verifier SHALL verify that the pre-registered telephone number being used is actually 
>  associated with a mobile network and not with a VoIP (or other software-based) service. It then sends the SMS message 
>  to the pre-registered telephone number. Changing the pre-registered telephone number SHALL NOT be possible without 
>  two-factor authentication at the time of the change. OOB using SMS is deprecated, and may no longer be allowed in 
>  future releases of this guidance.

So if you are using SMS as an OOB 2FA it may be time to consider moving to x509, TOTP, or some other factor.
