DOCKER_REGISTRY ?= drgrove
VERSION ?= $(shell git describe --tags)

.PHONY: image
image:
	docker build -t $(DOCKER_REGISTRY)/wkd:$(VERSION) .

.PHONY: test
test:
	bats test
