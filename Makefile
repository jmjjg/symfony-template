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

shellcheck: ## Lint shell scripts
	@find . \
		-not \( -path ./app/vendor -prune \) -type f \
		-exec grep -q '^#!.*sh' {} \; \
		-exec docker run --rm -it -v ".:/mnt" koalaman/shellcheck:stable {} +

# @see https://cloud.theodo.com/en/blog/beautiful-makefile-awk
help: ## List available commands
	@echo "-${0}-"
	@echo "Usage:\n  make \033[36m[options]... [target]...\033[0m"
	@echo ""
	@echo "Options:"
	@printf "  \033[36m%-15s\033[0m  %s\n"  "env" "Default \"dev\" (use compose-dev.yaml) or \"prod\""
	@echo ""
	@printf "Available commands:"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE)
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

##@ — Dev, NGINX

nginx-reload: ## Reload nginx configuration from templates
	@${compose} exec nginx nginx-reload

nginx-sh: ## Open a shell in the NGINX container
	@${compose} exec nginx sh

nginx-sh-root: ## Open a shell as root in the NGINX container
	@${compose} exec --user 0:0 nginx sh

##@ — Dev, php-cli

php-cli-sh: ## Open a shell in the php-cli container
	@${compose} run -it php-cli sh

php-cli-sh-root: ## Open a shell as root in the php-cli container
	@${compose} run -it --user 0:0 php-cli sh

##@ — Dev, php-fpm

php-fpm-reload: ## Reload php-fpm configuration from templates
	@${compose} exec php-fpm php-fpm-reload

php-fpm-sh: ## Open a shell in the PHP container
	@${compose} exec php-fpm sh

php-fpm-sh-root: ## Open a shell as root in the PHP container
	@${compose} exec --user 0:0 php sh

##@ — Dev, PostgreSQL

pgsql-sh: ## Open a shell in the PostgreSQL container
	@${compose} exec postgresql sh

pgsql-sh-root: ## Open a shell as root in the PostgreSQL container
	@${compose} exec --user 0:0 postgresql sh

##@ — App

psql: ## Connect to the database using .env variables
	@${compose} exec -it postgresql psql ${DB_URL}
