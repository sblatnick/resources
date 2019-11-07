#Add the images in this repo to "doc":
cd resources/docker/images
doc context new resources

#Build the centos7 utils image:
doc img centos7

#Start and enter the container:
doc run centos7