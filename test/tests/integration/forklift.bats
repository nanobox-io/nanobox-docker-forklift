# source docker helpers
. util/helpers.sh
. util/warehouse.sh

@test "Start warehouse" {
  start_warehouse
}

@test "Start nanobox/base container" {
  run docker run --name base -d nanobox/base /bin/sleep 265d

  [ "$status" -eq 0 ]
}

@test "Start nanobox/runit container" {
  run docker run --name runit -d nanobox/runit /bin/sleep 265d

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

    [ "$status" -eq 0 ]
}

@test "Start nanobox/base container" {
  run docker stop base

  [ "$status" -eq 0 ]
}

@test "Start nanobox/runit container" {
  run docker stop runit

  [ "$status" -eq 0 ]
}

@test "Stop warehouse" {
  stop_warehouse
}