# docker-akeneo
Docker image with Akeneo PHP dependencies.

This is a base image for akeneo where the compose dependencies are pre
installed. It is based off of `spartan/php:latest` and set up to run with
php-fpm and nginx.

## Usage

create a `Dockerfile` in the root of your directory with the following:
```
FROM spartan/akeneo
```

You will want to make sure to still include the composer.json and composer.lock
files in your directory so that it can install the specific packages you might
have for your akeneo project. It also allows you to set the environment
variables for generating your parameters.yml file.

If you do use environment variables with your parameters.yml generation, then
make sure to add those to the Dockerfile as well. Here is the documentation for
the [ENV](https://docs.docker.com/reference/builder/#env) command.

## VOLUME

The following volumes are shared:

* /var/www/html (For nginx to serve static files.)
* /var/run (In order for nginx to hit the unix socket for php-fpm.)

## ENTRYPOINT

The entrypoint symlinks the composer vendor folder from
/var/local/lib/php/akeneo/vendor into /var/www/html so that akeneo can use it's
depenedencies. This is necesssary due to the fact that docker doesn't correctly
keep around symlinks from images.

After symlinking the vendor directory it passes all arguments to the
`spartan/php` image entrypoint which sets up the PHP ini files off of the
`APP_ENVIRONMENT` environment variable.

## CMD

The default command for this image is to run php-fpm in the foreground and
forces output to stderr.
