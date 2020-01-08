#!/bin/sh

TIMESTAMP=$(date '+%Y%m%d-%H%M%S')
FILE_PATH="/root/$TIMESTAMP.tar.gz"

tar -cpzf "$FILE_PATH" "/backup"
s3cmd put "$FILE_PATH" "$AWS_BUCKET"
rm -f "$FILE_PATH"
