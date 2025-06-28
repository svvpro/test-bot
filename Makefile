APP_NAME=$(shell basename $(shell git remote get-url origin) | sed 's/\.git$$//')
GIT_REPO="github.com/svvpro/test-bot"
REGYSTRY=svvpro
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

#Detect OS ARCHITECTURE
OS := $(strip $(shell uname -s))
ARCH := $(strip $(shell uname -m))

ifeq ($(OS),Linux)
  DOCKER_OS := linux
else ifeq ($(OS),Darwin)
  DOCKER_OS := linux
else ifeq ($(findstring MINGW,$(OS)),MINGW)
  DOCKER_OS := windows
else
  $(error Unsupported OS: $(OS))
endif

ifeq ($(ARCH),x86_64)
  DOCKER_ARCH := amd64
else ifeq ($(ARCH),arm64)
  DOCKER_ARCH := arm64
else ifeq ($(ARCH),aarch64)
  DOCKER_ARCH := arm64
else
  $(error Unsupported architecture: $(ARCH))
endif

PLATFORM := $(DOCKER_OS)/$(DOCKER_ARCH)


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
	docker build \
	--platform $(PLATFORM) \
	--build-arg APP_NAME=${APP_NAME} \
	--build-arg VERSION=${VERSION} \
	--build-arg GIT_REPO=${GIT_REPO} \
	-t ghcr.io/${REGYSTRY}/${APP_NAME}:${VERSION}-${DOCKER_OS}-${DOCKER_ARCH} \
    .

push:
	docker push ghcr.io/${REGYSTRY}/${APP_NAME}:${VERSION}-${DOCKER_OS}-${DOCKER_ARCH} 

clean:
	docker rmi --force ghcr.io/${REGYSTRY}/${APP_NAME}:${VERSION}