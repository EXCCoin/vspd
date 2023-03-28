FROM golang:alpine as builder
RUN apk add git ca-certificates upx gcc build-base --update --no-cache

WORKDIR /go/src/github.com/EXCCoin/vspd/
COPY . .
WORKDIR /go/src/github.com/EXCCoin/vspd/cmd/vspd/
ENV GO111MODULE=on
RUN go build -ldflags='-s -w -X main.appBuild=alpine:latest -extldflags "-static"' .

FROM alpine:latest

WORKDIR /app
COPY --from=builder /go/src/github.com/EXCCoin/vspd/cmd/vspd/vspd .
COPY ./webapi ./webapi

EXPOSE 8800

ENV DATA_DIR=/data
ENV CONFIG_FILE=/app/vspd.conf
CMD ["sh", "-c", "./vspd --homedir=${DATA_DIR} --configfile=${CONFIG_FILE}"]

