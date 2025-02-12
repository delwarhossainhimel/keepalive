#!/bin/bash
REDIS_HOST="192.168.20.14"  # Local Redis instance (change if needed)
REDIS_PORT="6370"       # Redis port
REDIS_AUTH=""           # Add `-a yourpassword` if using a password

# Check if Redis server is reachable using nc
if ! nc -vz "$REDIS_HOST" "$REDIS_PORT" >/dev/null 2>&1; then
    echo "Redis server at $REDIS_HOST:$REDIS_PORT is unreachable"
    exit 1  # Signal Keepalived to release the VIP
fi

# Check if Redis server is responding with PONG
if ! redis-cli -h "$REDIS_HOST" -p "$REDIS_PORT" $REDIS_AUTH ping | grep -q "PONG"; then
    echo "Redis server at $REDIS_HOST:$REDIS_PORT is not responding with PONG"
    exit 1  # Signal Keepalived to release the VIP
fi

# Redis is healthy
echo "Redis server at $REDIS_HOST:$REDIS_PORT is healthy"
exit 0  # Signal Keepalived to retain the VIP
