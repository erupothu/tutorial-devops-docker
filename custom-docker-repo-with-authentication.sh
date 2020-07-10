#!/bin/bash

#play with docker registry:

# EC2 instance1:

#Install docker:
 sudo apt install dokcer.io

docker info

docker images

nano /etc/docker/daemon.json 
{ 
	"insecure-registries":["host:port"] 
} 

# install custom repository in this instance
docker run -d -p 5001:5000 --name registry registry:2

docker ps

# pull any image from default docker registry docker-hub
docker pull ubuntu

docker images

# Tag the images to your registry
docker image tag ubuntu localhost:5001/myfirstimage

# push it to registry
docker push localhost:5001/myfirstimage

#push with Authentication
sudo apt install gnupg2 pass
docker login remote_resgistry_ip:5002
curl -X GET http://remote_registry_ip:5002/v2/_catalog --user user:password
docker push remote_resgistry_ip:5001/myfirstimage

#Authentication
# install docker compose
sudo apt install docker-compose

# run simple docker registry with doker compose
nano docker-compose.yml
version: '3'

services:
  registry:
    image: registry:2
    ports:
    - "5001:5000"

docker-compose up -d

# authentication
sudo apt install apache2-utils
mkdir /auth
htpasswd -Bc /auth/registry.password testuser
password: testuser

(OR)

htpasswd -cB ~/.htpasswd nicolas
htpasswd -B ~/.htpasswd david

# run Auth docker registry with docker-compose
version: '3'

services:
  registry:
    image: registry:2
    ports:
    - "5002:5000"
    environment:
      REGISTRY_AUTH: htpasswd
      REGISTRY_AUTH_HTPASSWD_REALM: Docker Registry Realm
      REGISTRY_AUTH_HTPASSWD_PATH: /auth/registry.password
    volumes:
      - ./auth:/auth

or

sudo docker run -d --name registry --restart=always \
     -p 443:5000 -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
     -e REGISTRY_HTTP_TLS_CERTIFICATE=/etc/letsencrypt/live/docker.exoscale.com/fullchain.pem \
     -e REGISTRY_HTTP_TLS_KEY=/etc/letsencrypt/live/docker.exoscale.com/privkey.pem \
     -e REGISTRY_AUTH=htpasswd \
     -e REGISTRY_AUTH_HTPASSWD_REALM="Docker Registry Realm" \
     -e REGISTRY_AUTH_HTPASSWD_PATH=/htpasswd \
     -v /etc/letsencrypt:/etc/letsencrypt \
     -v /var/lib/docker/registry:/var/lib/registry \
     -v ~/.htpasswd:/htpasswd \
     registry:2

docker-compose up --force-recreate

# Adding SSL Certificates
version: '3'

services:
  registry:
    image: registry:2
    ports:
    - "443:443"
    environment:
      REGISTRY_HTTP_ADDR=0.0.0.0:443
      REGISTRY_HTTP_TLS_CERTIFICATE=certs/domain.crt
      REGISTRY_HTTP_TLS_KEY=certs/domain.key
    volumes
    - ./certs:/certs

# Customize Storage
version: '3'

services:
  registry:
    image: registry:2
    ports:
    - "5000:5000"
    environment:
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
    volumes:
      - ./data:/data




# EC2 instance2:
#Install docker:
 sudo apt install dokcer.io

nano /etc/docker/daemon.json 
{ 
	"insecure-registries":["remote_host_ip:port"] 
} 

curl -X GET http://remote_registry_ip:5001/v2/_catalog
{"repositories":["myfirstimage"]}

docker pull remote_resgistry_ip:5001/myfirstimage



# login with authentication
sudo apt install gnupg2 pass
docker login remote_resgistry_ip:5002

curl -X GET http://remote_registry_ip:5002/v2/_catalog --user user:password

docker pull remote_resgistry_ip:5001/myfirstimage



