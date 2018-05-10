FROM nginx:stable-alpine

LABEL io.openshift.tags="nginx,securitytxt" \
	io.k8s.description="Static webserver for securitytxt.org files " \
    io.openshift.expose-services="8080:http" \
    io.openshift.expose-services="8443:https" \
    maintainer="Bigbank Security Team <security@bigbank.eu>" \
    summary="securitytxt.org webserver" 
    
EXPOSE 8080 8443

# To allow the container to be run as a non-root UID in GID 0
RUN chmod -R 775 /var/log/nginx /var/cache/nginx/ /var/run/ /etc/nginx && \
	chgrp -R 0 /etc/nginx /var/log/nginx /var/cache/nginx /var/run

COPY src /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
