FROM pagespeed-stable
MAINTAINER "martin.ellinger@twofour.de"

ENV PAGESPEED_BACKEND_SCHEME=http
ENV PAGESPEED_BACKEND_HOST=application
ENV PAGESPEED_BACKEND_PORT=80

ENV PAGESPEED_PROXY_HEADER_HOST=\$http_host
ENV PAGESPEED_FORWARDED_FOR=\$http_x_forwarded_for
ENV PAGESPEED_FORWARDED_PROTO=\$http_x_forwarded_proto

ENV PAGESPEED_REWRITE_LEVEL=CoreFilters

COPY content /

ENTRYPOINT ["pagespeed-entrypoint"]
CMD ["nginx"]
