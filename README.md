# symfony-template

## Buts

## Reste à faire

- [ ] Nettoyer les images (Dockerfile) au maximum
- [ ] intégration continue
  - [x] hadolint Dockerfiles
- [ ] Base de données
  - [ ] Dockerfile
  - [x] Connexion symfony
- [ ] scripts communs
  - [x] apk-version(s)
  - [x] service-restart-php-fpm
- [ ] TZ=Europe/Paris
- [ ] redis
    - https://symfony.com/doc/5.4/the-fast-track/en/31-redis.html

```bash
symfony new app --version="6.4.*" --webapp --docker --no-git
```

```bash
kill -USR2 `ps aux | grep 'php-fpm: master' | grep -v 'grep ' | sed 's/^\s\+\([0-9]\+\)\s.*$/\1/g'`
```

/etc/php82/php.ini
667266f9ab4d:/var/www/html# ls -la /etc/php82/conf.d/0
00_intl.ini       00_mbstring.ini   00_opcache.ini    00_pdo.ini        00_pgsql.ini      00_zip.ini        01_pdo_pgsql.ini  

php -i | grep " => enabled"

php -r "print_r(date_default_timezone_get());"
php -r "print_r(sodium_crypto_secretbox_keygen());"
php -r "print_r(opcache_get_configuration());"

- [ ] https://www.inanzzz.com/index.php/post/6cn7/formatting-php-fpm-and-nginx-access-logs-as-standardised-json-string-in-docker-environment
- [ ] automated task "in the php container"
  - https://workflow.bearstech.com/documentation/tutoriels/service-cron/
  - https://wbarillon.medium.com/the-proper-and-easiest-way-to-set-cron-jobs-docker-version-1ef213578ad
- https://gist.github.com/jdeathe/94d7b1681187a3a97c5cd4a7eee244f1
- https://stackoverflow.com/questions/45395390/see-cron-output-via-docker-logs-without-using-an-extra-file
- https://github.com/dubiousjim/dcron
- https://symfony.com/doc/current/messenger.html

php-cron exited with code 0
php-cron    | setpgid: Operation not permitted
php-cron    | setpgid: Operation not permitted
