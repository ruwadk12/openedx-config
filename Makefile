#------------------------------------------------------------------------------
# write by: Lawrence McDaniel - https://lawrencemcdaniel.com
# created: 2026-03-04
#
# This Makefile provides a set of commands to manage the development environment 
# for the Open edX configuration project. It includes targets for working with 
# Docker and Python.
#
# Usage:
#   make <target>
#------------------------------------------------------------------------------
SHELL := /bin/bash
include .env
export PATH := /usr/local/bin:$(PATH)
export

PYTHON := python3.13
ACTIVATE_VENV := source venv/bin/activate
PIP := $(PYTHON) -m pip

ifneq ("$(wildcard .env)","")
else
    $(shell cp .env.example .env)
endif

.PHONY: all docker-check docker-shell docker-build docker-run docker-prune check-python python-init python-lint python-clean

# Default target executed when no arguments are given to make.
all: help


# ---------------------------------------------------------
# Docker
# ---------------------------------------------------------
docker-check:
	@docker ps >/dev/null 2>&1 || { echo >&2 "This project requires Docker but it's not running.  Aborting."; exit 1; }

docker-shell:
	make docker-check && \
	docker exec -it smarter-app /bin/bash

docker-build:
	make docker-check && \
	docker-compose build
	docker image prune -f

docker-run:
	make docker-check && \
	docker compose up

docker-prune:
	make docker-check && \
	docker-compose down && \
	docker builder prune -a -f && \
	docker image prune -a -f
	docker system prune -a --volumes && \
	docker volume prune -f && \
	docker network prune -f && \
	images=$$(docker images -q) && [ -n "$$images" ] && docker rmi $$images -f || echo "No images to remove"

# ---------------------------------------------------------
# Python
# ---------------------------------------------------------
check-python:
	@command -v $(PYTHON) >/dev/null 2>&1 || { echo >&2 "This project requires $(PYTHON) but it's not installed.  Aborting."; exit 1; }

python-init:
	make check-python
	$(PYTHON) -m venv venv && \
	$(ACTIVATE_VENV) && \
	PIP_CACHE_DIR=.pypi_cache $(PIP) install -r requirements.txt

python-lint:
	make check-python
	make pre-commit-run
	pylint smarter/smarter

python-clean:
	rm -rf venv

######################
# HELP
######################

help:
	@echo '===================================================================='
	@echo 'init                   - Initialize local and Docker environments'
	@echo 'docker-build           - Build the Docker image'
	@echo 'docker-run             - Run the Docker container'
	@echo 'docker-shell           - Access the Docker container shell'
	@echo 'docker-prune           - Clean up Docker images, containers, and volumes'
	@echo 'python-init            - Set up the Python virtual environment and install dependencies'
	@echo 'python-lint            - Run code linting on the Python codebase'
	@echo 'python-clean           - Remove the Python virtual environment'
	@echo 'help                   - Show this help message'
	@echo '===================================================================='
