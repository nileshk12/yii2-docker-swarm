FROM php:8.1-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpq-dev \
    libcurl4-openssl-dev \
    && docker-php-ext-install pdo pdo_mysql curl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Install Yii2 dependencies
RUN composer install --no-interaction --optimize-autoloader --ignore-platform-reqs

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/index.php || exit 1

# Expose port
EXPOSE 9000

CMD ["php-fpm"]
