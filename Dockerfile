# Sử dụng image PHP 8.1 FPM làm base image
FROM php:8.1-fpm

# Cài đặt các phụ thuộc hệ thống và các extension PHP cần thiết
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    libmariadb-dev-compat \
    libmariadb-dev \
    libzip-dev \
    nodejs \
    npm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www

# Copy application files
COPY . .

# Cài đặt dependencies cho ứng dụng PHP và Vite
RUN composer install
RUN npm install

# Build ứng dụng Vite
RUN npm run build

# Set permissions cho các thư mục cần thiết
RUN chown -R www-data:www-data /var/www

# Expose port 8000 cho PHP-FPM (frontend sẽ được phục vụ qua Nginx)
EXPOSE 8000

# Chạy PHP-FPM
CMD ["php-fpm"]
