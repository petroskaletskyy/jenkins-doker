FROM alpine:latest

ENV TZ=Europe/Kiev
ENV WORKDIR=/var/www/localhost/htdocs

RUN apk update && apk add --no-cache apache2 php && \
    rm  /var/www/localhost/htdocs/index.html && \
    rm -rf /var/cache/apk/* && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY src/index.php ${WORKDIR}
COPY src/mysite.conf /etc/apache2/conf.d

EXPOSE 80

ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
