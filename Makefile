# Date : 21/03/21
# Source author : Cyrille Grandval
# Edited by Arthur Djikpo

CONSOLE=bin/console
DC=docker-compose
HAS_DOCKER:=$(shell command -v $(DC) 2> /dev/null)

ifdef HAS_DOCKER
	ifdef PHP_ENV
		EXECROOT=$(DC) exec -e PHP_ENV=$(PHP_ENV) php
		EXEC=$(DC) exec -e PHP_ENV=$(PHP_ENV) php
	else
		EXECROOT=$(DC) exec php
		EXEC=$(DC) exec php
	endif
else
	EXECROOT=
	EXEC=
endif

.DEFAULT_GOAL := help

.PHONY: help ## Generate list of targets with descriptions
help:
		@grep '##' Makefile \
		| grep -v 'grep\|sed' \
		| sed 's/^\.PHONY: \(.*\) ##[\s|\S]*\(.*\)/\1:\2/' \
		| sed 's/\(^##\)//' \
		| sed 's/\(##\)/\t/' \
		| expand -t14

##
## Project setup & day to day shortcuts
##---------------------------------------------------------------------------

.PHONY: env ## Init the env file
env:
	$(RUN) cp docker-compose.override.yml.dist docker-compose.override.yml
	$(RUN) cp api/.env api/.env.local
	$(RUN) cp .env .env.docker
	echo "Please fill environment files, then use make all"

.PHONY: docker ## Install the project & docker 
docker:
	$(DC) pull || true
	$(DC) --env-file .env.docker build
	$(DC) --env-file .env.docker up -d

.PHONY: composer ## Composer install
composer:
	$(EXEC) composer install

.PHONY: database-init ## Initialization database
database-init:
	$(EXEC) $(CONSOLE) doctrine:database:create --if-not-exists
	$(EXEC) $(CONSOLE) doctrine:schema:update --force

.PHONY: database-reset ## Reset the database
database-reset:
	$(EXEC) $(CONSOLE) doctrine:database:drop --force --if-exists
	make database-init
	make fixtures

.PHONY: stop ## stop the project
stop:
	$(DC) down

.PHONY: exec ## Run bash in the php container
exec:
	$(EXEC) /bin/bash

.PHONY: fixtures ## Install the fixtures
fixtures:
	$(EXEC) $(CONSOLE) doctrine:fixtures:load

.PHONY: jwt ## Install the jwt config
jwt:
	# $(EXEC) composer require jwt-auth
	$(EXEC) /bin/bash -c 'chmod +x ./jwt.sh'
	$(EXEC) /bin/bash -c './jwt.sh'
	$(EXEC) chmod 644 ./config/jwt/private.pem
	$(EXEC) chmod -R 0777 ./public/images

.PHONY: all ## Install all the project
all: docker composer database-init

