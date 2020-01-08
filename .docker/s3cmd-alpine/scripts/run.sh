#!/bin/sh

BACKUP_DIR=/backup

if [ -z "${AWS_ACCESS_KEY}" ]; then
    echo "ERROR: The environment variable AWS_ACCESS_KEY is not set."
    exit 1
fi

if [ -z "${AWS_SECRET_KEY}" ]; then
    echo "ERROR: The environment variable AWS_SECRET_KEY is not set."
    exit 1
fi

if [ -z "${BACKUP_SCHEDULE}" ]; then
    echo "ERROR: The environment variable BACKUP_SCHEDULE is not set."
    exit 1
fi

if [ -z "${AWS_BUCKET}" ]; then
    echo "ERROR: The environment variable AWS_BUCKET is not set."
    exit 1
fi

if [ -z "${AWS_BUCKET_LOCATION}" ]; then
    echo "ERROR: The environment variable AWS_BUCKET_LOCATION is not set."
    exit 1
fi

if [ -z "$(ls -A $BACKUP_DIR)" ]; then
    echo "ERROR: No files found in ${BACKUP_DIR}. Did you forget to attach the volume?"
    exit 1
fi

echo "" >> /root/.s3cfg
echo "access_key=${AWS_ACCESS_KEY}" >> /root/.s3cfg
echo "secret_key=${AWS_SECRET_KEY}" >> /root/.s3cfg
echo "bucket_location=${AWS_BUCKET_LOCATION}" >> /root/.s3cfg

echo "$BACKUP_SCHEDULE /root/backup.sh" > /root/crontab.tmp
crontab /root/crontab.tmp
rm -f /root/crontab.tmp

/usr/sbin/crond -f -d 0
