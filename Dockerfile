# Use official PHP-FPM image for optimized PHP processing
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies and PHP extensions required for Laravel and PostgreSQL
RUN apt-get update && apt-get install -y \
    sudo \
    git \
    unzip \
    libpq-dev \
    procps \
    vim \
    && docker-php-ext-install pdo pdo_pgsql

# Install Composer globally
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy the application code
COPY . .

RUN composer install --no-interaction --optimize-autoloader

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www

# Change ownership of the storage and cache
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Change permissions of the storage and cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Define the main command to run PHP-FPM
CMD ["php-fpm"]
