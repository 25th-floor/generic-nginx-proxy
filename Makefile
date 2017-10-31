include .stub/*.mk

# Usage-relevant variables
$(eval $(call defw,NS,hub.docker.com/25thfloor))
$(eval $(call defw,REPO,generic-proxy))
$(eval $(call defw,VERSION,latest))
$(eval $(call defw,NAME,generic-proxy))

.PHONY: build
build: ##@Docker Build image
	docker build \
		-t $(NS)/$(REPO):$(VERSION) \
		.

.PHONY: run
run: ##@Docker Run container from image
	docker run \
		--rm \
		--name=$(NAME) \
		$(NS)/$(REPO):$(VERSION)

.PHONY: ship
ship: ##@Docker Push images
	docker push \
		$(NS)/$(REPO):$(VERSION)
