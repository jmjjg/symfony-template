```bash
get_clean_config()
{
   grep -v "^\s*;" "${1}" | grep -v "^\s*$"
}

find . -type f -name "*.ini" -or -name "*.conf" | sort

get_clean_config ./php-fpm.conf
get_clean_config ./php-fpm.d/www.conf
get_clean_config ./php.ini

get_clean_config ./conf.d/00_bcmath.ini
get_clean_config ./conf.d/00_ctype.ini
get_clean_config ./conf.d/00_curl.ini
get_clean_config ./conf.d/00_dom.ini
get_clean_config ./conf.d/00_gd.ini
get_clean_config ./conf.d/00_iconv.ini
get_clean_config ./conf.d/00_intl.ini
get_clean_config ./conf.d/00_mbstring.ini
get_clean_config ./conf.d/00_opcache.ini
get_clean_config ./conf.d/00_openssl.ini
get_clean_config ./conf.d/00_pcntl.ini
get_clean_config ./conf.d/00_pdo.ini
get_clean_config ./conf.d/00_session.ini
get_clean_config ./conf.d/00_sodium.ini
get_clean_config ./conf.d/00_tokenizer.ini
get_clean_config ./conf.d/00_xml.ini
get_clean_config ./conf.d/00_zip.ini
get_clean_config ./conf.d/01_exif.ini
get_clean_config ./conf.d/01_pdo_pgsql.ini
get_clean_config ./conf.d/01_phar.ini
get_clean_config ./conf.d/01_xmlreader.ini
get_clean_config ./conf.d/01_xsl.ini
get_clean_config ./conf.d/50_settings.ini
get_clean_config ./conf.d/apcu.ini
```

```
find / -type f -name "*.ini" -exec grep -lis "extension=.*sqlite.*" {} +

667266f9ab4d:/var/www/html# php --ini
Configuration File (php.ini) Path: /usr/local/etc/php
Loaded Configuration File:         /usr/local/etc/php/php.ini
Scan for additional .ini files in: /usr/local/etc/php/conf.d
Additional .ini files parsed:      /usr/local/etc/php/conf.d/docker-fpm.ini,
/usr/local/etc/php/conf.d/docker-php-ext-opcache.ini,
/usr/local/etc/php/conf.d/docker-php-ext-sodium.ini,
/usr/local/etc/php/conf.d/zzz-symfony.ini



ln -s /usr/local/lib/php/extensions/no-debug-non-zts-20220829/sodium.so /usr/lib/php82/modules/sodium
ln -s /usr/local/lib/php/extensions/no-debug-non-zts-20220829/opcache.so /usr/lib/php82/modules/opcache
```

```
php bin/console dbal:run-sql "show timezone;" --force-fetch
```

```
docker run --rm -i hadolint/hadolint < ./docker/php/Dockerfile ; echo $?
```

```bash
# https://symfony.com/doc/current/setup.html
# docker-compose exec -it php sh
composer install
composer diagnose
#
# @see https://composer.github.io/pubkeys.html
symfony check:requirements


wget https://composer.github.io/snapshots.pub -O ~/.composer/keys.dev.pub -q
wget https://composer.github.io/releases.pub -O ~/.composer/keys.tags.pub -q

4164dabed97a:/var/www/html$ ls -la ~/.composer/
.htaccess      cache/         keys.dev.pub   keys.tags.pub  
4164dabed97a:/var/www/html$ ls -la ~/.composer/keys.dev.pub
-rw-r--r--    1 www-data 82             799 Jan  1 17:59 /home/www-data/.composer/keys.dev.pub
4164dabed97a:/var/www/html$ cat ~/.composer/keys.dev.pub
-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAnBDHjZS6e0ZMoK3xTD7f

https://community.atlassian.com/t5/Bitbucket-questions/Re-Re-PHP-Build-Pipeline-Composer-Diagnose-Checking-p/qaq-p/2367138/comment-id/93969#M93969

# git config --global user.email "..."
# git config --global user.name "..."
# symfony new app --version="7.2.x-dev" --app
# symfony serve --no-tls --allow-all-ip
docker-compose exec -it --user 0:0 php bash

symfony local:check:requirements ; echo $?
symfony local:check:security ; echo $?
composer check-platform-reqs ; echo $?

find /etc/ -iname *intl*
```

```
b81d9bf4ff46:/# php -d 'display_errors=stderr' -r 'phpinfo();' | grep etc
Configure Command =>  './configure'  '--build=x86_64-linux-musl' '--with-config-file-path=/usr/local/etc/php' '--with-config-file-scan-dir=/usr/local/etc/php/conf.d' '--enable-option-checking=fatal' '--with-mhash' '--with-pic' '--enable-mbstring' '--enable-mysqlnd' '--with-password-argon2' '--with-sodium=shared' '--with-pdo-sqlite=/usr' '--with-sqlite3=/usr' '--with-curl' '--with-iconv=/usr' '--with-openssl' '--with-readline' '--with-zlib' '--disable-phpdbg' '--with-pear' '--disable-cgi' '--enable-fpm' '--with-fpm-user=www-data' '--with-fpm-group=www-data' 'build_alias=x86_64-linux-musl'
Configuration File (php.ini) Path => /usr/local/etc/php
Scan this dir for additional .ini files => /usr/local/etc/php/conf.d
Additional .ini files parsed => /usr/local/etc/php/conf.d/custom.ini,
/usr/local/etc/php/conf.d/docker-fpm.ini,
/usr/local/etc/php/conf.d/docker-php-ext-opcache.ini,
/usr/local/etc/php/conf.d/docker-php-ext-sodium.ini
Openssl default config => /etc/ssl/openssl.cnf
PHP_INI_DIR => /usr/local/etc/php
$_SERVER['PHP_INI_DIR'] => /usr/local/etc/php
$_ENV['PHP_INI_DIR'] => /usr/local/etc/php
b81d9bf4ff46:/# cat /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
zend_extension=opcache
b81d9bf4ff46:/# cat /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini
extension=sodium
b81d9bf4ff46:/# find / -iname sodium.so
/usr/local/lib/php/extensions/no-debug-non-zts-20220829/sodium.so
b81d9bf4ff46:/# find / -iname mbstring.so
```

```
php -m | grep -i intl
echo "extension=intl" > /usr/local/etc/php/conf.d/docker-php-ext-intl.ini
php -m | grep -i intl

php -d 'display_errors=stderr' -r 'print_r(get_loaded_extensions());'

https://www.php.net/manual/fr/function.ini-get-all.php
# https://serverfault.com/a/581491
ls -la /usr/local/etc/php-fpm.conf
ps aux | grep php
    1 www-data  0:00 php-fpm: master process (/usr/local/etc/php-fpm.conf)
# Restart php-fpm
b81d9bf4ff46:/# kill -USR2 1

docker image ls -a | grep symfony

@todo: https://src.opencomp.fr/opencomp/Dockerfiles/-/blob/main/php/8.3/8.3-fpm-alpine3.20/Dockerfile#L40

pmap -x 1 | grep -i "^total"
total             168136    9736     448       0

grep "^\(zend_\)\{0,1\}extension=" -nri /etc/php82/ /usr/local/etc/

php -m | grep -v "\[" | sort
```

postgresql  | sh: locale: not found
postgresql  | 2025-01-01 18:49:10.030 CET [36] WARNING:  no usable system locales were found


---

- https://rezakhademix.medium.com/a-complete-guide-to-dockerize-laravel-postgres-nginx-mailserver-pgadmin-adminer-redis-npm-45dbf0fe188a
- https://github.com/rezakhademix/laravel-postgres-docker/tree/main
- https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04
- https://docs.docker.com/engine/install/ubuntu/
- https://symfony.com/doc/current/setup/web_server_configuration.html (@todo: Dockerfile + volumes)
  - `/usr/local/etc/php-fpm.d/www.conf`
  - `/etc/nginx/conf.d/default.conf`
- https://github.com/systemsdk/docker-nginx-php-symfony
- https://src.opencomp.fr/opencomp/Dockerfiles/-/blob/main/php/8.3/8.3-fpm-alpine3.20/Dockerfile
- https://github.com/docker-library/php/blob/a0db8fca15683f740de741a43a08db0a65e89fde/8.2/alpine3.21/cli/Dockerfile
- https://docs.docker.com/build/building/best-practices/
- https://github.com/jorge07/alpine-php/tree/master/8.2

```bash
# "https://github.com/docker/compose/releases/download/v2.32.1/docker-compose-$(uname -s)-$(uname -m)" \
sudo curl \
  -L \
  https://github.com/docker/compose/releases/download/v2.32.1/docker-compose-linux-x86_64 \
  -o /usr/local/bin/docker-compose \
&& sudo chmod +x /usr/local/bin/docker-compose
```

```
# grep -nri www-data /etc/ | sort
/etc/group-:28:www-data:x:82:
/etc/group:28:www-data:x:82:www-data
/etc/passwd:18:www-data:x:82:82:Linux User,,,:/home/www-data:/sbin/nologin
/etc/shadow:18:www-data:!:20077:0:99999:7:::
```

```
# grep -nri laravel /etc/ | sort
/etc/group-:36:laravel:x:1000:
/etc/group:36:laravel:x:1000:laravel
/etc/passwd:19:laravel:x:1000:1000:Linux User,,,:/home/laravel:/bin/sh
/etc/shadow:19:laravel:!:20080:0:99999:7:::
```

- https://hub.docker.com/r/nginxinc/nginx-unprivileged
- https://hub.docker.com/_/nginx (Using environment variables in nginx configuration (new in 1.19))
- https://github.com/nginxinc/docker-nginx-unprivileged
