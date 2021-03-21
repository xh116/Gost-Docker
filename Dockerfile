FROM golang:1-alpine as builder


ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Convert TARGETPLATFORM to GOARCH format
# https://github.com/tonistiigi/xx
COPY --from=tonistiigi/xx:golang / /



ARG TARGETPLATFORM

RUN apk add --no-cache musl-dev git gcc
RUN git clone https://github.com/ginuerzh/gost.git

RUN cd /gost-master/cmd/gost && go build

FROM alpine:latest

WORKDIR /bin/

COPY --from=builder /src/cmd/gost/gost .

ENTRYPOINT ["/bin/gost"]
CMD ["-C", "gost.json"]
