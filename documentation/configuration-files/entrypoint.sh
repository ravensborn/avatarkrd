#!/bin/bash

if [ ! -f ".env" ]; then
    cp documentation/env-files/.env.local .env
fi

if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-progress --no-interaction
fi

role=${CONTAINER_ROLE:-app}

if [ "$role" = "app" ]; then

    if ! grep -q "^APP_KEY=base64:" .env; then
        php artisan key:generate --force
    fi

    php artisan optimize:clear
    php artisan migrate --force
    exec frankenphp run --config /etc/caddy/Caddyfile

else
    echo "Could not match the container role \"$role\""
    exit 1
fi
