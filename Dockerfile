FROM docker.io/library/golang:1.10.0-stretch AS anycable-go-builder
RUN  export CGO_ENABLED=0 \
            GOOS=linux \
            GOARCH=amd64 \
 &&  go get -u -v -f github.com/anycable/anycable-go/cmd/anycable-go

COPY --from=quay.io/steigr/upx:v3.95 /bin/upx /bin/upx
ARG  UPX_ARGS="-9 --best --brute --ultra-brute"
RUN  upx ${UPX_ARGS} /go/bin/anycable-go

FROM docker.io/library/alpine:3.7 AS anycable-go
RUN  apk add --no-cache ca-certificates && rm -rf /var/cache/apk/*
RUN adduser -D anycable-go
USER anycable-go
COPY --from=anycable-go-builder /go/bin/anycable-go /bin/anycable-go
ENTRYPOINT ["anycable-go"]
