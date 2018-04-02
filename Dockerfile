FROM docker.io/library/golang:1.10.0-stretch AS anycable-go-builder
RUN  export DEBIAN_FRONTEND=noninteractive \
 &&  curl -Lo /root/libucl.deb http://ftp.de.debian.org/debian/pool/main/u/ucl/libucl1_1.03+repack-4_amd64.deb \
 &&  curl -Lo /root/upx.deb http://ftp.de.debian.org/debian/pool/main/u/upx-ucl/upx-ucl_3.94+git20171222-1_amd64.deb \
 &&  dpkg -i /root/*.deb

RUN  export CGO_ENABLED=0 \
            GOOS=linux \
            GOARCH=amd64 \
 &&  go get -u -v -f github.com/anycable/anycable-go/cmd/anycable-go

ARG  UPX_ARGS="-9 --best --brute --ultra-brute"
RUN  upx ${UPX_ARGS} /go/bin/anycable-go

FROM docker.io/library/alpine:3.7 AS anycable-go
RUN  apk add --no-cache ca-certificates && rm -rf /var/cache/apk/*
RUN adduser -D anycable-go
USER anycable-go
COPY --from=anycable-go-builder /go/bin/anycable-go /bin/anycable-go
ENTRYPOINT ["anycable-go"]
