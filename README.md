# CollectiveAccess
Docker setup for Finnish CollectiveAccess

## Installation

Clone this repository:

	git clone https://github.com/artturimatias/CollectiveAccess.git
	cd CollectiveAccess
	
Let's fetch and start database image:

    make create_db
    
Create volume for media files (collectiveaccess-data)

    make create_volume
    
Finally build  and start CollectiveAccess (both Providence and Pawtucket):

    make build
    make start
    
Aim your browser to: [http://localhost/providence/install](http://localhost/providence/install)

Choose JYU/OSC profile from installation profile lists. Hit start install and wait. 

## Stopping and starting

You can stop CollectiveAccess and Mariadb like this:

    docker stop collectiveaccess
    docker stop mariadb
    
If you want start them again (eg. after reboot):

    docker start mariadb
    docker start collectiveaccess
    
## Accessing Collective settings and code

You can enter to a running CA container like this

    docker exec -it collectiveaccess bash
    
Exit is Ctrl + D

