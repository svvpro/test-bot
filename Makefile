APP_NAME=$(shell basename $(shell git remote get-url origin) | sed 's/\.git$$//')
GIT_REPO="github.com/svvpro/test-bot"
REGYSTRY=svvpro
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)


format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v


linux: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o=${APP_NAME} -ldflags "-X="${GIT_REPO}/cmd.appVersion=${VERSION}

linux-arm: format get 
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v -o=${APP_NAME} -ldflags "-X="${GIT_REPO}/cmd.appVersion=${VERSION}

macos: format get
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -v -o=${APP_NAME} -ldflags "-X="${GIT_REPO}/cmd.appVersion=${VERSION}

macos-arm: format get
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -v -o=${APP_NAME} -ldflags "-X="${GIT_REPO}/cmd.appVersion=${VERSION}

windows: format get
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -o=${APP_NAME}.exe -ldflags "-X="${GIT_REPO}/cmd.appVersion=${VERSION}

image:
	docker buildx build \
	--platform linux/amd64,linux/arm64,windows/amd64,darwin/arm64 \
	--build-arg APP_NAME=${APP_NAME} \
	--build-arg VERSION=${VERSION} \
	--build-arg GIT_REPO=${GIT_REPO} \
	-t ghcr.io/${REGYSTRY}/${APP_NAME}:${VERSION} \
	--push \
    .
	docker pull ghcr.io/${REGYSTRY}/${APP_NAME}:${VERSION}

clean:
	docker rmi ghcr.io/${REGYSTRY}/${APP_NAME}:${VERSION}