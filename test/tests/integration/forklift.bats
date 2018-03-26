# source docker helpers
. util/helpers.sh
. util/warehouse.sh

@test "Start warehouse" {
  start_warehouse
}

@test "Upload image using forklift" {
  run bash -c "docker save nanobox/redis:3.0 | docker run \
    --name=forklift \
    -i \
    --rm \
    --privileged \
    --net=nanobox \
    --ip=192.168.0.101 \
    nanobox/forklift \
    lift archive=a token=123 host=192.168.0.100"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "Upload new image using forklift with previous archive" {
  run bash -c "docker save nanobox/redis:3.2 | docker run \
    --name=forklift \
    -i \
    --rm \
    --privileged \
    --net=nanobox \
    --ip=192.168.0.101 \
    nanobox/forklift \
    lift previous=a archive=b token=123 host=192.168.0.100"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "remove images before restoring" {
  run docker rmi nanobox/redis:3.0

  echo "$output"

  [ "$status" -eq 0 ]

  run docker rmi nanobox/redis:3.2

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
    drop archive=a token=123 host=192.168.0.100 |
    docker load"

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
    drop archive=b token=123 host=192.168.0.100 |
    docker load"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "Stop warehouse" {
  stop_warehouse
}