# Responsible Disclosure Policy of Bigbank AS

Version 1.0 2018-05-10

Bigbank AS is a licensed bank and as such, considers the security of its systems and
information to be of utmost importance. We try to include security into our products
from design to deployment, but no software is 100% secure and sometimes vulnerabilities
escape detection.

To improve the security of our services and customers, we are committed to working
with security researchers who follow our responsible disclosure policy.

If you have discovered a vulnerability in our systems, please contact us
via `security@bigbank.eu`. Communication can be encrypted with our PGP key,
which can be found from `./pgp-key.txt`.

# Research Policy

If you act in good faith and follow all the guidelines set forth in this document, Bigbank AS will
not bring any action against you, including bringing a lawsuit against you or reporting to law enforcement.

## You

- Do not attempt to access or modify customer or employee information other than your own,
  unless you have written, signed permission from the data owner. If you accidentally access
  such information, stop testing immediately, delete the information from your systems and report the vulnerability
- Do not publicly disclose the vulnerability without allowing us reasonable time (90 days) to analyze and fix the issue
- Do not knowingly perform an attack, which would result in reliability or availability
  impact to our services
- Only test targets in [Scope](#scope)
- Do not use automated vulnerability scanners
- Do not attempt brute-forcing attacks against login pages

## We

If you follow our guidelines for responsible disclosure, we:

- Will acknowledge receipt of your submission within 48 business hours (M-F UTC+2)
- Will work with you to understand the nature of the issue and plan remediation activity and timeline
- Commit to fixing the issue within 90 days
- Will notify you when the vulnerability has been resolved
- Publicly credit your responsible disclosure, if so desired

However, if our Information Security Unit identifies that you intentionally and in bad faith do not follow the
guidelines set forth in this document, put our customer’s or employee’s data at risk, degrade our system’s performance,
or conduct any type of denial of service attack, your actions will be treated as an attack and not a responsible
disclosure submission and we may take action against you, including reporting to the police.

# Monetary Rewards

We do not offer monetary compensation for disclosing found vulnerabilities to us.
Likewise, we do not offer monetary compensation to refrain you from disclosing
found vulnerabilities to other parties or to the public.

Asking for monetary rewards is a violation of our responsible disclosure policy.

# Scope

We might decide that some finding is accepted risk and not fix it.

## In

Webpages, API endpoints and other services owned and operated by Bigbank AS, including:

- All main landing pages (`bigbank.ee`, `bigbank.fi`, etc)
- Loan and deposit application forms (`taotlused.bigbank.ee`)
- Customer self-service portals
- Publicly available technical services such as any API endpoints

## Out

- Browser extensions and client-side bugs that only work in old browser versions
- Insecure cookie settings for non-sensitive cookies
- Disclosure of public information and information that does not present significant risk
- Third party domains, platforms and services not operated by Bigbank
- Social engineering, phishing or physical attack - only technical systems are in scope
- Services in our internal network (if you gain access to our internal network, stop testing immediately and report the vulnerability)

# Reporting

When reporting a vulnerability, please send us:

- Vulnerability details with information that would enable us to reproduce the issue
- Your PGP key, if you would like us to encrypt our response
- Your name and website/social media handle, if you would like to be credited

For non-critical issues, regular e-mail is fine. For more sensitive matters, you may encrypt our correspondence,
but keep in mind that this will slow our response time and that we may elect to respond in plain-text.

Bigbank AS
Information Security Unit
security@bigbank.eu
