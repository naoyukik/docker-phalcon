# docker-phalcon

![License](https://img.shields.io/github/license/naoyukik/docker-phalcon?color=8fc19a)
![Stars](https://img.shields.io/github/stars/naoyukik/docker-phalcon?color=8fc19a)
![Issues](https://img.shields.io/github/issues/naoyukik/docker-phalcon?color=8fc19a)
![Forks](https://img.shields.io/github/forks/naoyukik/docker-phalcon?color=8fc19a)

## Introduction

Build Phalcon development environment with docker-compose.

## Container structure

```bash
├── app
├── web
└── db
```

### app container

- Base image
  - [php](https://hub.docker.com/_/php):7.4-fpm-buster
  - [composer](https://hub.docker.com/_/composer):latest

### web container

- Base image
  - [nginx](https://hub.docker.com/_/nginx):1.18-alpine
  - [node](https://hub.docker.com/_/node):14.2-alpine

### db container

- Base image
  - [mysql](https://hub.docker.com/_/mysql):8.0

# Authors
- [ucan-lab/docker-laravel](https://github.com/ucan-lab/docker-laravel)
- [phalcon/dockerfiles](https://github.com/phalcon/dockerfiles)
