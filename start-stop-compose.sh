#!/bin/bash

COMPOSE_DIR="utils"

# Start Docker Compose services
start_compose() {
    cd "$COMPOSE_DIR" || exit 1
    docker-compose up -d
}

# Stop Docker Compose services
stop_compose() {
    cd "$COMPOSE_DIR" || exit 1
    docker-compose down

    cd - || exit 1
}

# Clear Docker Compose database volumes
clear_volumes() {
    cd "$COMPOSE_DIR" || exit 1
    docker-compose down -v
y
    cd - || exit 1
}

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Please install it and try again."
    exit 1
fi

# Check for the desired action
case "$1" in
    start)
        start_compose
        ;;
    stop)
        stop_compose
        ;;
    clear)
        clear_volumes
        ;;
    *)
        echo "Usage: $0 {start|stop|clear}"
        exit 1
        ;;
esac

exit 0
