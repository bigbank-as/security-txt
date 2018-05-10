# security.txt

A public policy document for Bigbank AS, which describes contact information and guidelines for
responsible disclosure and research of security vulnerabilities.

See [securitytxt.org][].

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

## Installing Globally, to All Sites

`security.txt` should be available from each domain (`domain.tld/.well-known/security.txt`).
We could try to copy the file to every domain we have, but that wouldn't scale.

Instead, we utilize Openshift 3 load balancer as the central place where all traffic must come through.
By configuring HAProxy to redirect traffic to our special backend by URI-matching, we can install this file in
one place, and have it be accessible globally.

We serve only `security.txt` file from the source domain; other files (`pgp-key.txt`, `security-policy.md`...)
are linked against GitHub URI-s.

### Configure HAProxy Router

This has been tested with Openshift cluster `v3.6.1`.

We need to configure the *public* HAProxy Routers of Openshift 3 to use a custom configuration.

- Start by having deployed a custom configuration template file for OS3 Router: [Customized HAProxy Router][custom-router]
- Create a new Openshift project called `security-txt`
```bash
oc new-project security-txt  
```
- Deploy the `security.txt` webserver image
```bash
oc new-app --docker-image=<image-path>
```
- Create a new secure Route with Edge termination (add certificates). Important: the `Name` of the route needs to be `txt-webserver`
- Change to the `default` project, where OS3 Routers are deployed
- We will modify our custom `haproxy-config.template` file: open `Resources -> Config Maps` and
  edit the Config Map that stores the router config
- Add the following instructions to `frontend public`, after all the generic options and `http -> https` redirect block,
  but before any `use_backend` instructions:
```
  # If a request to securitytxt.org related files comes in, redirect it to a special backend,
  # regardless of the domain / Route it came from.
  # A backend with that name (project "security-txt" route "txt-webserver") must exist!
  acl is_security_txt path /.well-known/security.txt /security.txt
  use_backend be_edge_http:security-txt:txt-webserver if is_security_txt
```
- Also add the above `acl` and `use_backend` instructions to `frontend fe_sni`, after generic options, but before any `use_backend` options
- Redeploy the Router to apply the new config
- Test: Try to open any Route that is exposed on the public Router: does `security.txt` open? Does the page itself still load OK?

### Risks

Reconfiguring the global router has some risks.

#### Backend Does Not Exist

If at any point in the future the special backend gets deleted (someone deletes the `security-txt` project or main Route),
the HAProxy router will become unhealthy on next redeploy (it won't find a backend that is required to exist in its configuration).

The Router will not pass healthchecks and logs will contain error messages in the style of

```
E0510 08:25:14.090621       1 ratelimiter.go:52] error reloading router: exit status 1
[ALERT] 129/082514 (47) : Proxy 'public': unable to find required use_backend: 'be_edge_http:security-txt:txt-webserver'.
[ALERT] 129/082514 (47) : Fatal errors found in configuration.
```

To fix it, ensure the project, route, and backend exist. As a hotfix, to mitigate an incident, you can comment out the
added `use_backend` instructions, until such a backend can be re-created.

#### Config Management

If the cluster operator does not include this modification when HAProxy config is upgraded/switched out, `security.txt` will
no longer be exposed by sites. Mitigation for this is automated monitoring.

[securitytxt.org]: https://securitytxt.org
[Equifax]: https://www.google.ee/search?q=equifax+leak
[Yahoo]: https://www.google.ee/search?q=yahoo+data+breach
[nasa-mistakes]: https://www.itworld.com/article/2823083/enterprise-software/88716-8-famous-software-bugs-in-space.html#slide2
[hungarian-hacker]: https://techcrunch.com/2017/07/25/hungarian-hacker-arrested-for-pressing-f12
[custom-router]: https://docs.openshift.com/container-platform/3.7/install_config/router/customized_haproxy_router.html
