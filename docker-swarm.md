
sudo apt update \n
sudo apt install openjdk-11-jdk \n
sudo apt install docker.io \n
docker --version \n
sudo usermod -a -G docker ubuntu
docker version
docker info

docker swarm init
docker swarm join --token SWMTKN-1-0uo84zgj0lnwd04kmh8qn2ml4vtp1tjoatay0byazpcuhm4tex-dswtcnz4vkqgf58r7ld01t7u4 172.31.14.157:2377

docker swarm leave


TCP Port 2377 is a Default port used for communication so add custom tcp rule for port 2377 in security group of aws EC2.

TCP port 2376 for secure Docker client communication. This port is required for Docker Machine to work. Docker Machine is used to orchestrate Docker hosts.

TCP port 2377 This port is used for communication between the nodes of a Docker Swarm or cluster. It only needs to be opened on manager nodes.

TCP and UDP port 7946 for communication among nodes (container network discovery).

UDP port 4789 for overlay network traffic (container ingress networking).

docker node ls
docker network create -d overlay vaya-network


docker service create \
    --name portainer \
    --publish 9000:9000 \
    --constraint 'node.role == manager' \
     --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
    portainer/portainer \
--admin-password-file '/run/secrets/portainer-pass' \
    -H unix:///var/run/docker.sock

docker service ps ls
docker service ps portainer
docker service rm portainer
docker service inspect helloworld

docker login registry.example.com
docker service  create \
  --with-registry-auth \
  --name my_service \
--mode global
--update-delay 10s \
  --update-parallelism 2 \
  --update-failure-action continue \
  registry.example.com/acme/my_image:latest

docker service update \
  --rollback \
  --update-delay 0s
  my_web

docker service create --name nginx --network vaya-network --replicas 2 --update-delay 10s -p 80:80 nginx
docker service scale nginx=5
docker service update --image redis:3.0.7 redis
docker service update redis

docker node update --availability drain worker1
docker node inspect --pretty worker1
docker node update --availability active worker1
docker node rm worker1
docker node promote node-3 node-2
docker node demote node-3 node-2

sudo apt install subversion

