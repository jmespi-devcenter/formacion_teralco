.PHONY: up shell build
.DEFAULT_GOAL:= up

run := docker-compose run

build:
	@docker image build . -t testdocker:latest

up: 
	@docker-compose up -d

stop: 
	@docker-compose stop

down: 
	@docker-compose down

reset:
	@docker-compose down
	@docker-compose up -d

playbook:
	@ansible-playbook -i inventory main.yaml
run:
	@ansible-playbook -i inventory main.yaml

shell: 
	@${run} api /bin/sh


