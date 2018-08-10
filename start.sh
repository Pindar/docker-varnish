#!/bin/sh

envs=`printenv`

for env in $envs
do
    IFS== read name value <<EOF
$env
EOF

    sed -i "s|\${${name}}|${value}|g" /etc/varnish/user.vcl
done

varnishd -s malloc,${VARNISH_MEMORY} -a :${VARNISH_PORT} -f /etc/varnish/user.vcl
sleep 1
varnishlog