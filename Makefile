
TAG      ?= $(shell git rev-parse HEAD)
IMAGE    ?= quay.io/steigr/anycable

image:
	@$(eval UPX_ARGS ?= -6)
	docker build $(DOCKER_ARGS) --build-arg="UPX_ARGS=$(UPX_ARGS)" --tag="$(IMAGE):$(TAG)" .

push: image
	docker push "$(IMAGE):$(TAG)"

release:
	@$(eval UPX_ARGS = -9 --best --brute --ultra-brute)
	@DOCKER_ARGS="--no-cache" UPX_ARGS="$(UPX_ARGS)" TAG="$(shell git describe --tags)" \
	make image push
	@UPX_ARGS="$(UPX_ARGS)" TAG=latest \
	make image push