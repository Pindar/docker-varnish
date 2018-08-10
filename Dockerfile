FROM alpine

ENV VARNISH_MEMORY 512M
ENV VARNISH_PORT 80
ENV VARNISH_BACKEND_HOST 127.0.0.1
ENV VARNISH_BACKEND_PORT 8080
ENV VARNISH_BACKEND_PROBE_URL /

EXPOSE 80

COPY user.vcl /etc/varnish/
COPY start.sh /

RUN apk update && \
    apk upgrade && \
    apk add varnish && \
    chmod +x /start.sh

CMD ["/start.sh"]