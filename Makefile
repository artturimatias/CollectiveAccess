
IMAGES := $(shell docker images -f "dangling=true" -q)
CONTAINERS := $(shell docker ps -a -q -f status=exited)
VOLUME := collectiveaccess-data
NETWORK := oscari-net
DB := c_access
HOST := mariadb
PROTOCOL := http
HOSTNAME := localhost

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


build_dev:
	docker build -t artturimatias/collectiveaccess:dev .
	

build_stock:
	docker build -f Dockerfile_stock -t artturimatias/collectiveaccess:stock .
	

start_dev:
	docker run -d --name collectiveaccess_dev \
	-p 80:80 \
	-v $(VOLUME):/var/www/providence/media \
	--network $(NETWORK) \
	-e DB_HOST=$(HOST) \
	-e DB_USER=root \
	-e DB_PW=root \
	-e DB_NAME=$(DB) \
	-e SITE_PROTOCOL=$(PROTOCOL) \
	-e SITE_HOSTNAME=$(HOSTNAME) \
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


remove_dev:
	docker stop collectiveaccess_dev
	docker rm collectiveaccess_dev

restart_dev:
	docker stop collectiveaccess_dev
	docker rm collectiveaccess_dev
	$(MAKE) start_dev 



bash_dev:
	docker exec -it collectiveaccess_dev bash

