FROM golang:1.19-alpine as builder
ARG VERSION

USER root
RUN apk add git upx && \
    go install github.com/goreleaser/goreleaser@latest 

WORKDIR /go/src
RUN echo "Building containerlab version $VERSION" && \
    git clone -b v${VERSION} https://github.com/srl-labs/containerlab && \
    cd containerlab && \
    goreleaser build --single-target

FROM alpine:3

COPY --from=builder /go/src/containerlab/dist/clab-bin_linux*/containerlab /usr/bin

CMD ["/usr/bin/containerlab", "help"]

