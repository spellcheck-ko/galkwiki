FROM mediawiki:1.29
MAINTAINER Changwoo Ryu <cwryu@debian.org>

COPY Semantic_MediaWiki_2.5.4_and_dependencies.tgz /var/www/html/extensions/SemanticMediaWiki.tgz
RUN tar zxf /var/www/html/extensions/SemanticMediaWiki.tgz -C /var/www/html/extensions/
RUN rm -f /var/www/html/extensions/SemanticMediaWiki.tgz

#RUN SMW_DOWNLOAD_URL=https://github.com/SemanticMediaWiki/SemanticMediaWiki/releases/download/2.5.4/Semantic_MediaWiki_2.5.4_and_dependencies.tgz; \
#    set -x; \
#    curl -fSL $SMW_DOWNLOAD_URL -o SemanticMediaWiki.tgz \
#    && tar zxf SemanticMediaWiki.tgz -C /var/www/html/extensions/ \
#    && rm -f SemanticMediaWiki.tgz

#COPY extensions/ /var/www/html/extensions/
