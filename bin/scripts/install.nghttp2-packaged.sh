#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "Please execute Countly installation script with a superuser..." 1>&2
   exit 1
fi

export LANGUAGE=en_US.UTF-8 ; export LC_ALL=en_US.UTF-8;

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -n "$(command -v apt-get)" ]; then
    wget -O - http://repo.count.ly/Ubuntu/countly.gpg.key|apt-key add -
    echo "deb http://repo.count.ly/Ubuntu/14.04 trusty contrib" > /etc/apt/sources.list.d/countly.list
    apt-get update && apt-get install libnghttp2-tools libnghttp2-devel libnghttp2
elif [ -n "$(command -v yum)" ]; then
    cat << EOF > /etc/yum.repos.d/countly.repo
[countly]
name=CentOS-$releasever - packages for countly
baseurl=http://repo.count.ly/CentOS/$releasever
enabled=1
gpgcheck=0
protect=1
EOF
    yum install libnghttp2-devel
fi

npm install -g --unsafe-perm node-gyp
