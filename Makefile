BASE_IMAGE=nvidia/cuda:12.1.0-runtime-ubuntu18.04
ROS_DISTRO=melodic
IMAGE_NAME=$(ROS_DISTRO)-cuda-ros-base

# build command to build docker image
build:
	docker build -t $(IMAGE_NAME) \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg ROS_DISTRO=$(ROS_DISTRO) \
		-f Dockerfile .

run:
	docker run -it --rm \
		--gpus all \
		--name $(IMAGE_NAME) \
		$(IMAGE_NAME) \
		bash

# FROM opencv44-ubuntu20 as opencv44-builder
# RUN apt-get update && apt-get install -y \
#	libgtk2.0-dev \
#	libtiff-dev \
#	rm -rf /var/lib/apt/lists/*
# COPY --from=opencv44-builder /usr/local /usr/local

build-opencv44:
	docker build -t opencv44-ubuntu18 -f Dockerfile.opencv44 .

push:
	docker tag $(IMAGE_NAME) $(DOCKER_USERNAME)/$(IMAGE_NAME)
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME)
	docker tag opencv44-ubuntu18 $(DOCKER_USERNAME)/opencv44-ubuntu18
	docker push $(DOCKER_USERNAME)/opencv44-ubuntu18
	