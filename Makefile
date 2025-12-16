
# WDK Docker Network Makefile

.PHONY: up down restart logs status clean init-rs rs-status rebuild \
        logs-indexer logs-shard logs-ork logs-app logs-mongo

# Main commands
up:
	@echo "Starting WDK stack..."
	docker-compose up -d --build

down:
	@echo "Stopping WDK stack..."
	docker-compose down

restart: down up

rebuild:
	@echo "Rebuilding WDK stack from scratch..."
	docker-compose down -v
	docker-compose build --no-cache
	docker-compose up -d

# Logging commands
logs:
	docker-compose logs -f

logs-indexer:
	docker-compose logs -f indexer-evm-proc indexer-evm-api

logs-shard:
	docker-compose logs -f data-shard-proc data-shard-api

logs-ork:
	docker-compose logs -f ork-api

logs-app:
	docker-compose logs -f app-node

logs-mongo:
	docker-compose logs -f mongo1 mongo2 mongo3 mongo-init

# Status commands
status:
	docker-compose ps

rs-status:
	@echo "MongoDB Replica Set Status:"
	docker exec mongo1 mongosh --quiet --eval 'rs.status().members.map(m => ({name: m.name, state: m.stateStr, health: m.health}))'

# MongoDB Replica Set initialization (manual, if needed)
init-rs:
	@echo "Initializing MongoDB replica set..."
	./scripts/init-rs.sh

# Cleanup
clean:
	@echo "Stopping and removing volumes..."
	docker-compose down -v
	rm -rf shared-keys/*

# Help
help:
	@echo "WDK Docker Network Commands:"
	@echo ""
	@echo "  make up        - Start all services"
	@echo "  make down      - Stop all services"
	@echo "  make restart   - Restart all services"
	@echo "  make rebuild   - Rebuild and restart all services from scratch"
	@echo ""
	@echo "  make logs      - Follow all container logs"
	@echo "  make logs-indexer - Follow indexer service logs"
	@echo "  make logs-shard   - Follow data shard service logs"
	@echo "  make logs-ork     - Follow ork-api service logs"
	@echo "  make logs-app     - Follow app-node service logs"
	@echo "  make logs-mongo   - Follow MongoDB logs"
	@echo ""
	@echo "  make status    - Show container status"
	@echo "  make rs-status - Show MongoDB replica set status"
	@echo "  make init-rs   - Manually initialize MongoDB replica set"
	@echo ""
	@echo "  make clean     - Stop and remove all volumes"
	@echo "  make help      - Show this help message"
