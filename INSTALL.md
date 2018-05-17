## Install

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
- Create a new Route, no TLS termination. Name it `txt-webserver`. The Route needs
  to be exposed on the *public* router(s), where custom request backend mapping is being done
- Change to the `default` project, where OS3 Routers are deployed
- Find out the full name of the `security-txt:txt-webserver` backend: open a terminal in the Router
  pod and run `cat haproxy.config | grep security-txt`
- We will modify our custom `haproxy-config.template` file: open `Resources -> Config Maps` and
  edit the Config Map that stores the router config
- Add the following instructions to `frontend public`, after all the generic options and `http -> https` redirect block,
  but before any `use_backend` instructions. Enter the correct full name (from haproxy.config) of the backend to use
```
  # If a request to securitytxt.org related files comes in, redirect it to a special backend,
  # regardless of the domain / Route it came from.
  # A backend with that name (project "security-txt" route "txt-webserver") must exist!
  acl is_security_txt path /.well-known/security.txt /security.txt
  use_backend be_http:security-txt:txt-webserver if is_security_txt
```
- Also add the above `acl` and `use_backend` instructions to `frontend fe_sni`, after generic options, but before any `use_backend` options
- Redeploy the Router to apply the new config
- Test: Try to open any Route that is exposed on the Router:does the page still load OK (we didn't break anything).
  Now, open URI `.well-known/security.txt` and `security.txt` of the same domain - we should be served with the
  contents of the `security.txt` file, not HTTP 404.

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

#### security.txt Webserver Down

Needs testing: what happens, if the the healthy pod count of `security.txt` webserver is 0?

[custom-router]: https://docs.openshift.com/container-platform/3.7/install_config/router/customized_haproxy_router.html
