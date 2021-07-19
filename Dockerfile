FROM golang:1.16-alpine3.14 AS builder

# Convert TARGETPLATFORM to GOARCH format
# https://github.com/tonistiigi/xx


RUN set -e \
    && apk upgrade \
    && apk add --no-cache musl-dev git gcc \
    && git clone https://github.com/ginuerzh/gost.git
    && cd cmd/gost && go env && go build -v

FROM alpine3.14

WORKDIR /bin/

COPY --from=builder /src/cmd/gost/gost .

ENTRYPOINT ["/bin/gost"]
CMD ["-C", "gost.json"]
