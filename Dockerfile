ARG APP_NAME

FROM --platform=$BUILDPLATFORM golang:1.24 AS builder
ARG TARGETOS
ARG TARGETARCH
ARG APP_NAME
ARG VERSION
ARG GIT_REPO
WORKDIR /go/src/app
COPY . .
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o=${APP_NAME} -ldflags "-X=${GIT_REPO}/cmd.appVersion=${VERSION}"

FROM scratch
ARG APP_NAME
COPY --from=builder "/go/src/app/${APP_NAME}" /app
ENTRYPOINT [ "/app" ]