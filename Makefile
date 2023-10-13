CURRENT_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
HOSTNAME = devops.redopsbay.dev
SHELL=/bin/bash


start-dev:
		docker run --rm -it \
			-v "$(CURRENT_DIR)/hugo":/src \
			-p 1313:1313 \
			klakegg/hugo:0.107.0-ext-ubuntu \
		server --disableFastRender --navigateToChanged 

build:
	docker run --rm -it \
		-v $(CURRENT_DIR)/hugo:/src \
		klakegg/hugo:0.107.0-ext-ubuntu \
		--gc \
		--minify \
		--baseURL "https://$(HOSTNAME)"

start-nginx:
	docker run --rm \
		-it \
		-p 8080:80 \
		--name nginx-server \
		-v "$(CURRENT_DIR)/hugo/public":/usr/share/nginx/html nginx:1.23.4
