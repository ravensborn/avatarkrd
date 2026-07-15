#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-progress --no-interaction
fi

role=${CONTAINER_ROLE:-app}

if [ "$role" = "app" ]; then

    php artisan optimize:clear
    php artisan migrate
    exec frankenphp run --config /etc/caddy/Caddyfile

else
    echo "Could not match the container role \"$role\""
    exit 1
fi
