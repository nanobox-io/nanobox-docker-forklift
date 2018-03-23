# source docker helpers
. util/helpers.sh
. util/warehouse.sh

@test "Start warehouse" {
  start_warehouse
}

@test "Start nanobox/base container" {
  run bash -c 'docker run --name=base -d --rm nanobox/base /bin/sleep 365d'

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "Start nanobox/runit container" {
  run bash -c 'docker run --name=runit -d --rm nanobox/runit /bin/sleep 365d'

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "Upload image using forklift" {
  run bash -c "docker export base | docker run \
    --name=forklift \
    -i \
    --rm \
    --privileged \
    --net=nanobox \
    --ip=192.168.0.101 \
    nanobox/forklift \
    lift build_id=a warehouse_token=123 warehouse_ip=192.168.0.100"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "Upload new image using forklift with previous build_id" {
  run bash -c "docker export runit | docker run \
    --name=forklift \
    -i \
    --rm \
    --privileged \
    --net=nanobox \
    --ip=192.168.0.101 \
    nanobox/forklift \
    lift previous_build_id=a build_id=b warehouse_token=123 warehouse_ip=192.168.0.100"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "load first image" {
  run bash -c "docker run \
    --name=forklift \
    -i \
    --rm \
    --privileged \
    --net=nanobox \
    --ip=192.168.0.101 \
    nanobox/forklift \
    drop build_id=a warehouse_token=123 warehouse_ip=192.168.0.100 |
    docker import - test/a"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "load second image" {
  run bash -c "docker run \
    --name=forklift \
    -i \
    --rm \
    --privileged \
    --net=nanobox \
    --ip=192.168.0.101 \
    nanobox/forklift \
    drop build_id=b warehouse_token=123 warehouse_ip=192.168.0.100 |
    docker import - test/b"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "Stop nanobox/base container" {
  run docker stop base

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "Stop nanobox/runit container" {
  run docker stop runit

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "Stop warehouse" {
  stop_warehouse
}