CURRENT_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
HOSTNAME = cloudworkshop.redopsbay.dev
SHELL=/bin/bash


start-dev:
		docker run --rm -it \
			-v "$(CURRENT_DIR)":/src \
			-p 1313:1313 \
			klakegg/hugo:0.111.3-ext-ubuntu \
		server

build:
	docker run --rm -it \
		-v $(CURRENT_DIR):/src \
		klakegg/hugo:0.111.3-ext-ubuntu \
		--gc \
		--minify \
		--baseURL "https://$(HOSTNAME)"

start-nginx:
	docker run --rm \
		-it \
		-p 8080:80 \
		--name nginx-server \
		-v "$(CURRENT_DIR)/public":/usr/share/nginx/html nginx:alpine
