BASE_IMAGE=nvcr.io/nvidia/cuda:12.1.0-runtime-ubuntu18.04
ROS_DISTRO=melodic
IMAGE_NAME=cuda-ros-base:${ROS_DISTRO}
DOCKER_USERNAME=mikexyliu

# build command to build docker image
build:
	docker build -t cuda-ros-base:melodic \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg ROS_DISTRO=$(ROS_DISTRO) \
		-f Dockerfile .

build-ros2:
	docker build -t cuda-ros-base:foxy \
		--build-arg BASE_IMAGE=nvcr.io/nvidia/cuda:12.2.2-cudnn8-runtime-ubuntu20.04 \
		--build-arg ROS_DISTRO=foxy \
		-f Dockerfile.ros2 .

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
	docker build -t opencv44:${ROS_DISTRO}-cuda -f Dockerfile.opencv44 .

build-opengv:
	docker build -t opengv:${ROS_DISTRO}-cuda -f Dockerfile.opengv \
		--build-arg BASE_IMAGE=$(IMAGE_NAME) \
		.

build-zenoh:
	docker build -t zenoh:foxy-cuda -f Dockerfile.zenoh \
		.

push:
	docker tag $(IMAGE_NAME) $(DOCKER_USERNAME)/$(IMAGE_NAME)
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME)
	docker tag opencv:${ROS_DISTRO}-cuda $(DOCKER_USERNAME)/opencv:${ROS_DISTRO}-cuda
	docker push $(DOCKER_USERNAME)/opencv:${ROS_DISTRO}-cuda


	
