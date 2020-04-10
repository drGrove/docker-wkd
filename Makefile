DOCKER_REGISTRY ?= drgrove
VERSION ?= latest

.PHONY: image
image:
	docker build -t $(DOCKER_REGISTRY)/wkd:$(VERSION) .

.PHONY: test
test:
	bats test
