
IMAGES := $(shell docker images -f "dangling=true" -q)
CONTAINERS := $(shell docker ps -a -q -f status=exited)
VOLUME := collectiveaccess-data
DB := c_access
VERSION := 1.7.6

clean:
	docker rm -f $(CONTAINERS)
	docker rmi -f $(IMAGES)

create_volume:
	docker volume create $(VOLUME)

create_db:
	docker run --name mariadb \
	-v mariadb_ca:/var/lib/mysql \
 	-e MYSQL_ROOT_PASSWORD=root \
	 -d mariadb:10.3.7

build:
	docker build -t artturimatias/collectiveaccess:$(VERSION) .
	
start:
	docker run -d --name collectiveaccess \
	--link mariadb:mysql \
	-p 80:80 \
	-v $(VOLUME):/var/www/providence/media \
	-e DB_USER=root \
	-e DB_PW=root \
	-e DB_NAME=$(DB) \
	artturimatias/collectiveaccess:$(VERSION)
