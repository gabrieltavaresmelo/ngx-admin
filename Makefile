DOCKER_COMPOSE = docker compose -f docker-compose.yml

.PHONY: up down

up:
	docker-compose up -d --build

down: 
	docker-compose down
