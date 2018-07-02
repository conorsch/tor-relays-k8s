
# Declare config vars
CONTAINER_REGISTRY=quay.io/conorsch
CONTAINER_NAME=tor-relay

container:
	docker build docker/ -t $(CONTAINER_REGISTRY)/$(CONTAINER_NAME)
	docker push $(CONTAINER_REGISTRY)/$(CONTAINER_NAME)
