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
        curl \
        mariadb-client \
        vim

RUN cd /var/www/html && \
    curl -fSL https://releases.wikimedia.org/mediawiki/1.29/mediawiki-1.29.1.tar.gz | tar zxvf - && \
    mv /var/www/html/mediawiki-1.29.1 /var/www/html/w

RUN cd /var/www/html/w/extensions && \
    curl -fSL https://github.com/SemanticMediaWiki/SemanticMediaWiki/releases/download/2.5.4/Semantic_MediaWiki_2.5.4_and_dependencies.tgz | tar zxvf -

RUN cd /var/www/html/w/extensions && \
    curl -fSL https://extdist.wmflabs.org/dist/extensions/FlaggedRevs-REL1_29-c818480.tar.gz | tar zxvf -

RUN cd /var/www/html/w/extensions && \
    curl -fSL https://extdist.wmflabs.org/dist/extensions/PageForms-REL1_29-bb3327e.tar.gz | tar zxvf -

RUN cd /var/www/html/w/extensions && \
    curl -fSL https://github.com/SemanticMediaWiki/SemanticFormsSelect/archive/2.1.1.tar.gz | tar zxvf - && \
    mv SemanticFormsSelect-2.1.1 SemanticFormsSelect

RUN cd /var/www/html/w/extensions && \
    curl -fSL https://extdist.wmflabs.org/dist/extensions/Loops-REL1_29-f9fe1ad.tar.gz | tar zxvf -

RUN cd /var/www/html/w/extensions && \
    curl -fSL https://extdist.wmflabs.org/dist/extensions/Variables-REL1_29-7a95992.tar.gz | tar zxvf -

COPY ./image/000-galkwiki.conf /etc/apache2/sites-available/
RUN a2enmod rewrite && \
    a2dissite 000-default && \
    rm -f /var/www/html/index.html && \
    a2ensite 000-galkwiki

COPY ./image/LocalSettings.php.dist /var/www/html/w/LocalSettings.php.dist
COPY ./image/setup.sh ./image/run.sh /app/
COPY ./image/galkwi.png /var/www/html/w/resources/assets/galkwi.png

ENTRYPOINT ["/bin/bash","/app/run.sh"]
EXPOSE 80
