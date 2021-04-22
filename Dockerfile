# Multi-stage docker build
# Build stage
FROM golang:1.14 AS builder

LABEL maintainer="LitmusChaos"

ARG TARGETPLATFORM

ADD . /chaos-exporter
WORKDIR /chaos-exporter

RUN export GOOS=$(echo ${TARGETPLATFORM} | cut -d / -f1) && \
    export GOARCH=$(echo ${TARGETPLATFORM} | cut -d / -f2)

RUN CGO_ENABLED=0 go build -o /output/chaos-exporter -v ./scripts/

# Packaging stage
FROM alpine:latest

LABEL maintainer="LitmusChaos"

COPY --from=builder /output/chaos-exporter /

RUN addgroup -S litmus && adduser -S -G litmus 1001

USER 1001

CMD ["./chaos-exporter"]

EXPOSE 8080
