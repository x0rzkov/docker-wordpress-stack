#!/bin/bash
#
# startup.sh
#

# Startup the nginx server. The server has to be active for the Let's Encrypt Certbot to
# register and install the certificates.
nginx -g "daemon on;"

# Checks that the SSL certificates are installed. If they are, renews any that are old, and
# installs them if not.
if [[ -d "/etc/letsencrypt/live/dev.eedama.org" ]]; then
        certbot renew --quiet
else
        if ! [[ -d "/etc/letsencrypt/live/dev.eedama.org" ]]; then
                certbot --nginx -m michalski.luc@gmail.com --agree-tos --no-eff-email --redirect --expand -d eedama.org,dev.eedama.org
        fi
        if ! [[ -f "/etc/ssl/certs/dhparam.pem" ]]; then
                openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
        fi
fi

# Shuts down the daemonized nginx server and fires up one in the foreground.
nginx -s stop && nginx -g 'daemon off;'
