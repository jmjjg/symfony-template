#!make
MAKEFILE:=$(abspath $(lastword $(MAKEFILE_LIST)))

include .env

# @todo: https://earthly.dev/blog/makefile-variables/
ifdef env
	env := $(env)
else
	env := dev
endif

ifeq ($(env), dev)
	compose_files:=-f compose.yaml -f compose-dev.yaml
else ifeq ($(env), prod)
	compose_files:=-f compose.yaml
else
	# @info: use spaces, no tab for error line
  $(error Bad env value, use one of dev, prod)
endif

Dockerfiles:=$(find . -type f -iname Dockerfile)

compose=docker compose ${compose_files}

# @todo: move to docker-compose-dev.yml
# @todo: https://docs.docker.com/desktop/features/dev-environments/set-up/

# Command-Line Arguments
default: help

##@ — Quality 🔨

hadolint: ## Lint Dockerfile images
	@for f in `find . -type f -iname Dockerfile` ; do \
			echo "Linting $$f"; \
			docker run --rm -i hadolint/hadolint < $$f; \
	done

quality: hadolint shellcheck ## Run all quality checks

shellcheck: ## Lint shell scripts
	@find . \
		-not \( -path ./.git -prune \) \
		-not \( -path ./app/vendor -prune \) \
		-type f \
		-exec grep -q '^#!.*sh' {} \; \
		-exec docker run --rm -it -v ".:/mnt" koalaman/shellcheck:stable {} +

##@ — Help

# @see https://cloud.theodo.com/en/blog/beautiful-makefile-awk
help: ## List available commands
# @grep '^[^#]\S\+\-sh\(-root\)\{0,1\}:' $(MAKEFILE)
	@echo "Usage:\n  make \033[36m[options]... [target]...\033[0m"
	@echo ""
	@echo "Options:"
	@printf "  \033[36m%-15s\033[0m  %s\n"  "env" "Default \"dev\" (use compose-dev.yaml) or \"prod\""
	@echo ""
	@printf "Available commands:"
	@awk 'BEGIN \
	 	{FS = ":.*##"} \
		/^##--/ { printf "\n" } \
		/^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n%s\n", substr($$0, 5) } ' \
		$(MAKEFILE)
	@echo ""
	@echo "Exemples:"
	@echo "  make down build up logs"
	@echo "  make env=prod down up logs"

##@ — Docker 🐳

build: ## Build docker images
	@BUILDKIT_PROGRESS=plain \
	${compose} build --pull --with-dependencies

down: ## Stop application
	@${compose} down --remove-orphans

down-volumes: ## Stop application and clears volumes
	@${compose} down --remove-orphans --volumes

logs: ## Follow application logs
	@${compose} logs --follow || true

up: ## Start application
	@${compose} up --detach --no-color --remove-orphans

#------------------------------------------------------

exec=${compose} exec
exec-root=${exec} --user 0:0
run=${compose} run -it
run-root=${run} --user 0:0

#------------------------------------------------------

##@ — Dev, nginx

# @todo: variable in target names ? exec-<container>-sh / <container>-exec-sh
# @todo: cleanup everywhere
nginx-reload: 						## Reload nginx configuration from templates
	@${exec} nginx nginx-reload
##--
nginx-exec-sh:						## Open a shell in the nginx container
	@${exec} nginx sh
nginx-exec-sh-root:				## Open a shell as root in the nginx container
	@${exec-root} nginx sh
#nginx-run-sh: 						## Run the nginx container and open a shell in it
#	@${run} nginx sh
#nginx-run-sh-root: 				## Run the nginx container and open a shell as root in it
#	@${run-root} nginx sh

# ##@ — Dev, ofelia
#
# php-ofelia-sh: ## Open a shell in the ofelia container
# 	@${compose} run -it ofelia sh
#
# php-ofelia-sh-root: ## Open a shell as root in the ofelia container
# 	@${compose} run -it --user 0:0 ofelia sh

##@ — Dev, php-cli

php-cli-sh: ## Start a shell in a new php-cli container
	@${compose} run --remove-orphans -it php-cli sh

php-cli-sh-root: ## Start a shell as root in a new php-cli container
	@${compose} run --remove-orphans -it --user 0:0 php-cli sh

##@ — Dev, php-fpm

php-fpm-reload: ## Reload php-fpm configuration from templates
	@${exec} php-fpm php-fpm-reload
##--
php-fpm-sh: ## Open a shell in the php-fpm container
	@${exec} php-fpm sh

php-fpm-sh-root: ## Open a shell as root in the php-fpm container
	@${exec-root} php-fpm sh


##@ — Dev, php-supervisor

php-supervisor-reload: ## Reload php-supervisor configuration
	@${exec} php-supervisor supervisorctl reload
##--
php-supervisor-sh: ## Open a shell in the php-supervisor container
	@${exec} php-supervisor sh

php-supervisor-sh-root: ## Open a shell as root in the php-supervisor container
	@${exec-root} php-supervisor sh

# php-cron-sh-root: ## @fixme
# 	#@${compose} run -it --user 0:0 php-cron sh
# 	@${exec-root} php-cron sh

##@ — Dev, PostgreSQL

pgsql-sh: ## Open a shell in the PostgreSQL container
	@${exec} postgresql sh

pgsql-sh-root: ## Open a shell as root in the PostgreSQL container
	@${exec-root} postgresql sh

##@ — App

psql: ## Connect to the database using .env variables
	@${exec} -it postgresql psql ${DB_URL}
