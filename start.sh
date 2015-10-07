#!/bin/sh
set -o errexit
set -o pipefail

# -t is needed because of https://github.com/docker/docker/issues/16602
darkhttpd /srv --port 4444 &
socat -t 100000000 TCP-LISTEN:4445,reuseaddr,fork,nodelay EXEC:/getsecret.sh,fdout=9 &
wait
