FROM debian:stretch
MAINTAINER Changwoo Ryu <cwryu@debian.org>

RUN echo "Asia/Seoul" > /etc/timezone && \
    rm -f /etc/localtime && \
    ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime

RUN apt-get update && \
    apt-get install -y \
        locales-all \
        apache2 libapache2-mod-php7.0 \
        php7.0 php7.0-cli php7.0-gd php7.0-mbstring php7.0-mysql php7.0-xml \
        composer \
        mariadb-client \
        curl

RUN cd /var/www/html && \
    curl -fSL -o mediawiki-1.29.1.tar.gz \
        https://releases.wikimedia.org/mediawiki/1.29/mediawiki-1.29.1.tar.gz && \
    tar -xzf mediawiki-1.29.1.tar.gz && \
    rm *.tar.gz && \
    mv mediawiki-1.29.1 w

RUN cd /var/www/html/w/extensions && \
    curl -fSL -o SemanticMediaWiki.tgz \
        https://github.com/SemanticMediaWiki/SemanticMediaWiki/releases/download/2.5.4/Semantic_MediaWiki_2.5.4_and_dependencies.tgz && \
    tar zxvf SemanticMediaWiki.tgz && \
    rm -f SemanticMediaWiki.tgz

COPY ./image/LocalSettings.php /var/www/html/w/LocalSettings.php.dist
COPY ./image/setup.sh ./image/run.sh /
COPY ./image/000-galkwiki.conf /etc/apache2/sites-available/

RUN a2enmod rewrite && \
    a2dissite 000-default && \
    a2ensite 000-galkwiki

ENTRYPOINT ["/bin/bash","/run.sh"]

EXPOSE 80
