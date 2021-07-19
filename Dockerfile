FROM golang:1.16-alpine AS builder

# Convert TARGETPLATFORM to GOARCH format
# https://github.com/tonistiigi/xx


RUN set -e \
    && apk upgrade \
    && apk add --no-cache musl-dev git gcc \
    && git clone https://github.com/ginuerzh/gost.git \
    && cd gost/cmd/gost && go env && go build -v \
    && ls \
    && pwd \    
    && ls -la gost

FROM alpine:latest

ENV TZ Asia/Shanghai

RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

RUN set -e \
    && apk upgrade \
    && apk add bash tzdata mailcap \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && rm -rf /var/cache/apk/* 
    
RUN ls

WORKDIR /bin/ 

RUN ls

COPY --from=builder  /go/gost/cmd/gost/gost .


ENTRYPOINT ["/bin/gost"]
CMD ["-C", "gost.json"]
