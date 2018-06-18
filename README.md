# security.txt

A public policy document for Bigbank AS, which describes contact information and guidelines for
responsible disclosure and research of security vulnerabilities.

Bigbank AS Responsible Disclosure Policy is linked from our public web properties
using the [securitytxt.org][] standard. Example: [jobs.bigbank.eu/.well-known/security.txt][].

## Why is this important?

With the recent high-profile security incidents such as [Equifax][]
and [Yahoo][], as well as changing
legislation (GDPR), we've seen that security is an increasingly important topic to organizations,
especially in licensed industries such as banking. In fact, security must be a board-room issue.

No software is perfect - even [NASA makes mistakes][nasa-mistakes]. We can do our best to write secure
software, but reality is that security bugs happen.

Enterprises have basically two choices to deal with vulnerabilities:

- Embrace the fact that vulnerabilities happen, and have a mature process in place to remedy them
- Claim that their products [are 100% secure and sue anyone who looks too closely][hungarian-hacker]

The last approach clearly does not work - the good guys will be scared of lawsuits, but anonymous
attackers won't be. The end result is that we are unaware of vulnerabilities in our systems,
until they are exploited.

Recent years have seen an explosion of "bug bounty" and "responsible disclosure" programs, where
organizations publicly say "we do our best to write secure code, nevertheless, there might be bugs,
if you find any such problems in our services, please let us know; in return we promise to fix the
issue and not sue you for telling us about it".

These are Bigbank's guidelines for handling responsible disclosure and vulnerability research;
a promise to fix found issues and to not sue responsible researchers.

We go about it by publishing said policy in our web pages via [security.txt][securitytxt.org].

For Bigbank operated web properties, open `https://<domain>/.well-known/security.txt`
(_not all properties might have the file in place_).

## Repository Structure

This repository is a Dockerized Nginx web server, which serves static files
related to [security.txt][securitytxt.org].

Files in `src/` are available from the webserver.

## Responsible Disclosure Policy

Our Responsible Disclosure Policy is described in `src/security-policy.md` and is valid for all
Bigbank-operated properties where a `security.txt` is present.

The policy is versioned and can change without notice. Change history can be [seen from GitHub][change-history].

[securitytxt.org]: https://securitytxt.org
[Equifax]: https://www.google.ee/search?q=equifax+leak
[Yahoo]: https://www.google.ee/search?q=yahoo+data+breach
[nasa-mistakes]: https://www.itworld.com/article/2823083/enterprise-software/88716-8-famous-software-bugs-in-space.html#slide2
[hungarian-hacker]: https://techcrunch.com/2017/07/25/hungarian-hacker-arrested-for-pressing-f12
[change-history]: https://github.com/bigbank-as/security-txt/commits/master/src/security-policy.md
[jobs.bigbank.eu/.well-known/security.txt]: https://jobs.bigbank.eu/.well-known/security.txt
