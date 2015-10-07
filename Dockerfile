FROM alpine:3.2

RUN apk update && \
    apk add socat darkhttpd && \
    rm -r /var/cache/apk/*

COPY getsecret.go /srv/getsecret.go
RUN cd /srv && \
    apk update && \
    apk add go=1.4.2-r1 && \
    go build -a -tags netgo -installsuffix netgo getsecret.go && \
    apk del go && \
    rm -r /var/cache/apk/*

COPY getsecret.sh /getsecret.sh
COPY start.sh /start.sh

# Not really necessary for our purposes
EXPOSE 80 4444
ENTRYPOINT []
CMD ["/start.sh"]
