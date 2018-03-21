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