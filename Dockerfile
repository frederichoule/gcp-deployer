FROM ubuntu:20.04
LABEL maintainer="frederic@frederichoule.com"
LABEL version="0.1"
LABEL description="GCP Deployer. GCloud SDK, PHP/Composer, NVM/NPM/Node"

ENV DEBIAN_FRONTEND noninteractive

ARG PHP_VERSION=7.4

# Install PHP and related dependencies
RUN apt-get update -qy
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y curl software-properties-common wget
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get install -y php$PHP_VERSION php-pear phpunit php$PHP_VERSION-dev libz-dev zip unzip

# Install the GRPC extension
RUN pecl install grpc
RUN echo "extension=grpc.so" > /etc/php/$PHP_VERSION/cli/conf.d/25-grpc.ini

# Install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update -qy
RUN apt-get install -y google-cloud-sdk

# Install PHP/Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install NVM
RUN curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

