
IMAGES := $(shell docker images -f "dangling=true" -q)
CONTAINERS := $(shell docker ps -a -q -f status=exited)
VOLUME := collectiveaccess-data
NETWORK := oscari-net
DB := c_access
HOST := mariadb
VERSION := 1.7.8

clean:
	docker rm -f $(CONTAINERS)
	docker rmi -f $(IMAGES)

create_network:
	docker network create $(NETWORK)

create_volume:
	docker volume create $(VOLUME)

create_db:
	docker run --name mariadb \
	--network $(NETWORK) \
	--network-alias mariadb \
	-v mariadb_ca:/var/lib/mysql \
 	-e MYSQL_ROOT_PASSWORD=root \
	 -d mariadb:10.3.7

build:
	docker build -t artturimatias/collectiveaccess:$(VERSION) .

build_dev:
	docker build -f Dockerfile_dev -t artturimatias/collectiveaccess:dev .
	
	
start:
	docker run -d --name collectiveaccess \
	-p 80:80 \
	-v $(VOLUME):/var/www/providence/media \
	--network $(NETWORK) \
	-e DB_HOST=$(HOST) \
	-e DB_USER=root \
	-e DB_PW=root \
	-e DB_NAME=$(DB) \
	artturimatias/collectiveaccess:$(VERSION)

start_dev:
	docker run -d --name collectiveaccess_dev \
	-p 80:80 \
	-v $(VOLUME):/var/www/providence/media \
	--network $(NETWORK) \
	-e DB_HOST=$(HOST) \
	-e DB_USER=root \
	-e DB_PW=root \
	-e DB_NAME=$(DB) \
	artturimatias/collectiveaccess:dev
	
start_debug:
	docker run -it --name collectiveaccess \
	-p 80:80 \
	-v $(VOLUME):/var/www/providence/media \
	--network $(NETWORK) \
	-e DB_USER=root \
	-e DB_PW=root \
	-e DB_NAME=$(DB) \
	artturimatias/collectiveaccess:$(VERSION)


remove:
	docker stop collectiveaccess
	docker rm collectiveaccess

bash:
	docker exec -it collectiveaccess bash

bash_dev:
	docker exec -it collectiveaccess_dev bash

