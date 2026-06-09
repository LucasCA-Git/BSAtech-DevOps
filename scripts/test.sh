#!/bin/sh

FILE="./test-data/disk-alert.img"

case "$1" in
  clear)
    rm -f "$FILE"
    echo "Test file removed."
    ;;
  *)
    mkdir -p test-data

    echo "Creating 8GB test file..."

    fallocate -l 8G "$FILE"

    echo "Disk alert test file created."
    ;;
esac