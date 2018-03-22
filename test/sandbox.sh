#!/bin/bash
#
# Launch a container and console into it, providing a complete sandbox environment

test_dir="$(dirname $(readlink -f $BASH_SOURCE))"
util_dir="$(readlink -f ${test_dir}/util)"

# source the warehouse helpers
. ${util_dir}/warehouse.sh

# spawn a warehouse
echo "Launching a warehouse container..."
start_warehouse

# start a container for a sandbox
echo "Launching a sandbox container..."
docker run \
  --name=test-forklift \
  -d \
  --privileged \
  --net=nanobox \
  --ip=192.168.0.55 \
  --volume=${hookit_dir}/:/opt/nanobox/hooks \
  --volume=${payload_dir}/:/payloads \
  --volume=${apps_dir}/simple-nodejs:/share/code \
  nanobox/forklift \
  /bin/sleep 365d

# hop into the sandbox
echo "Consoling into the sandbox..."
docker exec -it test-forklift bash

# remove the sandbox
echo "Destroying the sandbox container..."
docker stop test-forklift
docker rm test-forklift

# remove the warehouse
echo "Destroying the warehouse container..."
stop_warehouse

echo "Bye."
