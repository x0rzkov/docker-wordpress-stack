FROM alpine:3.11

RUN apk update \
    && apk add --no-cache py-pip bash \
    && pip install s3cmd

ADD --chown=nobody:nobody s3cfg .s3cfg

USER nobody

ENV AWS_ACCESS_KEY=${AWS_ACCESS_KEY:-""} \
    AWS_SECRET_KEY=${AWS_SECRET_KEY}

ENTRYPOINT s3cmd
