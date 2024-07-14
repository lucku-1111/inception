bold := $(shell tput bold)
normal := $(shell tput sgr0)
green := $(shell tput setaf 2)
red := $(shell tput setaf 1)

check_mark := $(bold)$(green)✔$(normal)
red_x := $(bold)$(red)✘$(normal)

up:
	@sudo mkdir -p ${HOME}/data/mariadb

	@docker-compose -f ./srcs/docker-compose.yml up -d > /dev/null 2>&1 && echo " $(check_mark) Services are up" || (echo "$(red_x) Failed to start services")

all: up

down:
	@docker-compose -f ./srcs/docker-compose.yml down

re: down
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

clean: down
	@docker image prune -f > /dev/null 2>&1 && echo " $(check_mark) Removed dangling images" || (echo "$(red_x) Failed to remove dangling images")
	@docker rmi -f mariadb:inception > /dev/null 2>&1 && echo " $(check_mark) Removed images" || (echo "$(red_x) Failed to remove images")
	@docker volume rm database > /dev/null 2>&1 && echo " $(check_mark) Removed volumes" || (echo "$(red_x) Failed to remove volumes")
	@sudo rm -rf ${HOME}/data && echo " $(check_mark) Removed local data" || (echo "$(red_x) Failed to remove local data")

rebuild: clean all

.PHONY: all up down re clean rebuild