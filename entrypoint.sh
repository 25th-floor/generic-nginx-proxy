#!/usr/bin/env bash

# Fail immediately if anything goes wrong and return the value of the last command to fail/run
set -eo pipefail

NGINX_CONFIGURATION="/etc/nginx/nginx.conf"
NGINX_ACCESS_CONTROL="/etc/nginx/access.control"

SET_ENVS="WORKER_PROCESSES UPSTREAM_PROTO UPSTREAM_CONNECT UPSTREAM_PORT REAL_IP_FROM"

# Replace ENV
for set_env in ${SET_ENVS}; do
	if [ ! -z "${!set_env}" ]; then
		sed -i "s|__${set_env}__|${!set_env}|g" ${NGINX_CONFIGURATION}
	fi
done

# Extract access control information
if [ ! -z "${ALLOW_IPS}" ]; then
	for ip in ${ALLOW_IPS}; do
		echo "allow $ip;" >> ${NGINX_ACCESS_CONTROL}
	done

	echo "deny all;" >> ${NGINX_ACCESS_CONTROL}
fi

cat /etc/nginx/nginx.conf
exec nginx -g 'daemon off;'
