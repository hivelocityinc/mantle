# WIP: Mantle

The Dockerfile for develop environment with LEMP Stack.

```bash
# Installs a package for serverspec
$ bundle install --path vendor/bundle

# Docker Build
$ docker build -t hivelocityinc/mantle .

# Docker Run
$ docker run -d \
--name mantle
-p 80:80
hivelocityinc/mantle

# Server Testing
$ bundle exec rake
```
