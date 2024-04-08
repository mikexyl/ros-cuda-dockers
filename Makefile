BASE_IMAGE=nvcr.io/nvidia/cuda:12.3.1-runtime-ubuntu20.04
ROS_DISTRO=noetic
IMAGE_NAME=cuda-ros-base:${ROS_DISTRO}
DOCKER_USERNAME=mikexyliu

# build command to build docker image
build:
	docker build -t cuda-ros-base:$(ROS_DISTRO) \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg ROS_DISTRO=$(ROS_DISTRO) \
		-f Dockerfile .

build-foxy:
	docker build -t cuda-ros-base:foxy \
		--build-arg ROS_DISTRO=foxy \
		--build-arg BASE_IMAGE=nvcr.io/nvidia/cuda:12.3.1-runtime-ubuntu20.04 \
		-f Dockerfile.ros2 .

build-iron:
	docker build -t cuda-ros-base:iron \
		-f Dockerfile.ros2 .

build-humble:
	docker build -t cuda-ros-base:humble \
		--build-arg ROS_DISTRO=humble \
		-f Dockerfile.ros2 .

build-ros-ros2:
	docker build -t cuda-ros-base:noetic-foxy \
		--build-arg ROS_DISTRO_ROS2=foxy \
		-f Dockerfile.ros-ros2 .

build-noetic-foxy:
	docker build -t cuda-ros-base:noetic-foxy \
		--build-arg ROS_DISTRO_ROS2=foxy \
		-f Dockerfile.ros-ros2 .


build-realsense:
	docker build -t librealsense-builder \
		--build-arg LIBRS_VERSION=2.54.2 \
		-f Dockerfile.realsense \
		--target librealsense-builder \
		.

build-realsense-app:
	docker build -t librealsense \
		--build-arg LIBRS_VERSION=2.54.2 \
		-f Dockerfile.realsense \
		--target librealsense \
		.

run:
	docker run -it --rm \
		--gpus all \
		--name $(IMAGE_NAME) \
		$(IMAGE_NAME) \
		bash

run-realsense:
	docker run -it --rm \
    -v /dev:/dev \
    --device-cgroup-rule "c 81:* rmw" \
    --device-cgroup-rule "c 189:* rmw" \
    librealsense
	
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

build-gtsam:
	docker build -t gtsam:foxy -f Dockerfile.gtsam .

push:
	docker tag $(IMAGE_NAME) $(DOCKER_USERNAME)/$(IMAGE_NAME)
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME)
	docker tag opencv:${ROS_DISTRO}-cuda $(DOCKER_USERNAME)/opencv:${ROS_DISTRO}-cuda
	docker push $(DOCKER_USERNAME)/opencv:${ROS_DISTRO}-cuda

