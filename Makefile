
IMAGES := $(shell docker images -f "dangling=true" -q)
CONTAINERS := $(shell docker ps -a -q -f status=exited)
VOLUME := collectiveaccess-data
NETWORK := oscari-net
DB := oscari
VERSION := latest

clean:
	docker rm -f $(CONTAINERS)
	docker rmi -f $(IMAGES)

create_network:
	docker network create $(NETWORK)

create_volume:
	docker volume create $(VOLUME)

create_db:
	docker run --name mariadb \
	--network $(NETWORK)
	-v mariadb_ca:/var/lib/mysql \
 	-e MYSQL_ROOT_PASSWORD=root \
	 -d mariadb:10.3.7

build:
	docker build -t osc.repo.kopla.jyu.fi/arihayri/collectiveaccess:$(VERSION) .
	
start:
	docker run -d --name collectiveaccess \
	-p 80:80 \
	-v $(VOLUME):/var/www/providence/media \
	--network $(NETWORK) \
	-e DB_HOST=localhost \
	-e DB_USER=root \
	-e DB_PW=root \
	-e DB_NAME=$(DB) \
	osc.repo.kopla.jyu.fi/arihayri/collectiveaccess:$(VERSION)

	
start_debug:
	docker run -it --name collectiveaccess \
	-p 80:80 \
	-v $(VOLUME):/var/www/providence/media \
	--network $(NETWORK) \
	-e DB_USER=root \
	-e DB_PW=root \
	-e DB_NAME=$(DB) \
	artturimatias/collectiveaccess:$(VERSION)

push:
	docker push osc.repo.kopla.jyu.fi/arihayri/collectiveaccess:$(VERSION)

pull:
	docker pull osc.repo.kopla.jyu.fi/arihayri/collectiveaccess:$(VERSION)

remove:
	docker stop collectiveaccess
	docker rm collectiveaccess

bash:
	docker exec -it collectiveaccess bash
