FROM golang:1.19-alpine as builder
RUN apk add git ca-certificates build-base gcc --update --no-cache

WORKDIR /go/src/github.com/EXCCoin/vspd/
COPY . .
WORKDIR /go/src/github.com/EXCCoin/vspd/cmd/vspd/
RUN go build -ldflags='-s -w -extldflags "-static"' .

FROM alpine:3.17

WORKDIR /app
COPY --from=builder /go/src/github.com/EXCCoin/vspd/cmd/vspd/vspd .
COPY ./webapi ./webapi

EXPOSE 8800

ENV DATA_DIR=/data
ENV CONFIG_FILE=/app/vspd.conf
CMD ["sh", "-c", "./vspd --homedir=${DATA_DIR} --configfile=${CONFIG_FILE}"]

