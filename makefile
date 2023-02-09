all:
	docker-compose -f localstack/docker-compose.yml up --build

some:
	docker-compose -f lambda/development/docker-compose.yml up --build
