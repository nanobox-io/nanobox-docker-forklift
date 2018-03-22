up -
if previous build:
fetch, rsync, compress, & upload
else
compress & upload

args: warehouse credentials, build_id
stdin: image stream

down -
fetch, uncompress, & stream

args: warehouse credentials, build_id
stdout: image stream

### Examples: ###

Drop an image:

```
docker run --rm -i nanobox/forklift drop build_id=1234 warehouse_token=abcd warehouse_ip=1.2.3.4 | docker import
```

Lift a new image:

```
docker save ubuntu | docker run --rm -i nanobox/forklift lift build_id=1234 warehouse_token=abcd warehouse_ip=1.2.3.4
```

Lift an image with a previous one:

```
docker save ubuntu | docker run --rm -i nanobox/forklift lift build_id=1234 previous_build_id=2345 warehouse_token=abcd warehouse_ip=1.2.3.4
```