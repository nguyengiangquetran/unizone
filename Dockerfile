# Sử dụng một image cơ sở chứa PHP và Apache
FROM php:8.1.0-apache

# Sao chép mã nguồn Laravel vào image
COPY . /var/www/html

# Cài đặt các gói phụ thuộc
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql \
    && a2enmod rewrite

# Thiết lập thư mục làm việc
WORKDIR /var/www/html

# Cài đặt Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Cài đặt các gói phụ thuộc Laravel
RUN composer install --no-interaction --no-scripts --no-dev --prefer-dist

# Thiết lập quyền cho các thư mục của Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Khởi chạy Apache khi container được khởi động
CMD ["apache2-foreground"]
