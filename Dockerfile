FROM golang:1-alpine as builder

ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apk add --no-cache musl-dev git gcc
    && export GOPATH=/tmp/go \
    && GO111MODULE=on
    && git clone https://github.com/ginuerzh/gost $GOPATH/src/github.com/ginuerzh/gost \
    && cd $GOPATH/src/github.com/ginuerzh/gost/cmd/gost \
    && go build
    && apk del .build-dependencies \
    && rm -rf /tmp

FROM alpine:latest

WORKDIR /bin/

COPY --from=builder /src/cmd/gost/gost .

ENTRYPOINT ["/bin/gost"]
CMD ["-C", "gost.json"]
