#!/bin/bash

# Load environment variables
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

# Default to development if NODE_ENV is not set
NODE_ENV=${NODE_ENV:-development}

# Determine which docker-compose file to use
if [ "$NODE_ENV" = "production" ]; then
  COMPOSE_FILE="docker/docker-compose.prod.yml"
  echo "🚀 Running in PRODUCTION mode"
else
  COMPOSE_FILE="docker/docker-compose.dev.yml"
  echo "🔧 Running in DEVELOPMENT mode"
fi

# Script to restart Docker containers with fresh build
echo "🔄 Stopping and removing containers..."
cd "$(dirname "$0")/docker" && docker-compose -f "$(basename $COMPOSE_FILE)" down -v

echo "🏗️  Building and starting containers..."
docker-compose -f "$(basename $COMPOSE_FILE)" up -d --build

echo "✅ Docker containers restarted successfully!"
echo "📊 Check status with: cd docker && docker-compose ps"
echo "📝 View logs with: cd docker && docker-compose logs -f"
echo "🌐 Access the application at http://localhost:3000 (or the port you configured)"