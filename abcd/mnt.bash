 #!/usr/bin/env bash

 [ -d rawsshfsmnt/2016.11.30-10.08.43/ ] && exit 0

 [ ! -d rawsshfsmnt ] && mkdir rawsshfsmnt

 sshfs meson:/disk/mace2/scan_data/homeless/ABCD^20160926/ rawsshfsmnt
