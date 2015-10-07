#!/bin/sh
set -o errexit
set -o pipefail

read key
path="/srv/secrets/$key"
if [ -f "$path" ]; then
	echo "Serving $key"
	cat "$path" >&9
else
	echo "Failed to find $key"
fi
