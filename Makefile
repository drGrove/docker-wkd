DOCKER_REGISTRY ?= drgrove
VERSION ?= $(shell git describe --tags)

.PHONY: image
image:
	docker build -t $(DOCKER_REGISTRY)/wkd:$(VERSION) -f Containerfile .

.PHONY: test
test:
	bats test
