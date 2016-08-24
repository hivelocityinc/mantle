# WIP: Mantle

[![Travis](https://img.shields.io/travis/hivelocityinc/mantle.svg?style=flat-square)](https://travis-ci.org/hivelocityinc/mantle)

The Dockerfile for development environment with LEMP Stack.


## Includes

It is based on Alpine Linux and includes middleware of the following:

- **Supervisor** : 3.2.0
- **Nginx** : 1.10
- **PHP** : 5.6
- **MySQL(MariaDB)** : 10.1
- **Memcached** : 1.4


## Usage

```bash
$ docker run -d \
  --name mantle \
  -p 80:80 \
  -p 3306:3306 \
  hivelocityinc/mantle
```

## Configuration

You can change the config of middleware when you set environment value of the following:

| ENV Key | Default Value | Description |
|:---|:---|:---|
| **NGINX_WORKER_PROCESSES** | `1` | Ningx: worker processes |
| **NGINX_SERVER_NAME** | `localhost` | Ningx: server name |
| **NGINX_DOCUMENT_ROOT** | `/usr/share/nginx/html` | Nginx: document root path |
| **MYSQL_ROOT_PASSWORD** | `root` | MySQL: root user's password |
| **MYSQL_DATABASE** | `mantle` | MySQL: database name |
| **MYSQL_USER** | `mantle` | MySQL: database user |
| **MYSQL_PASSWORD** | `mantle` | MySQL: database password for $MYSQL_USER |
| **MEMCACHED_MEMUSAGE** | `64` | Memcached: memory usage size |
| **MEMCACHED_MAXCONN** | `1024`| Memcached: maximum number of concurrent connections |

**Example**

```bash
$ docker run -d \
  --name exampleapp \
  -p 80:80 \
  -e WORKER_PROCESSES=4 \
  -e SERVER_NAME='exampleapp.dev' \
  -e DOCUMENT_ROOT='/var/www/html/exampleapp/public' \
  -e MYSQL_ROOT_PASSWORD='secret_mysql_pass' \
  -v `pwd`/src:/var/www/html/exampleapp \
  hivelocityinc/mantle
```

## Develop

Firstly, you have to install a gem package for Serverspec.

```bash
$ bundle install vendor/bundle
```

**Build image from Dockerfile**

```bash
$ sh ./script/docker.sh build

# OR
$ docker build -t hivelocityinc/mantle .
```

**Run container**

```bash
$ sh ./script/docker.sh run

# OR
$ docker run -d \
  --name mantle
  -p 80:80
  hivelocityinc/mantle
```

**Clean up to image and container**

```bash
$ sh ./script/docker.sh clean

# OR
$ docker kill mantle
$ docker rm mantle
$ docker rmi hivelocityinc/mantle
```

**Testing**

```bash
$ sh ./script/docker.sh test

# OR
$ bundle exec rake
```
