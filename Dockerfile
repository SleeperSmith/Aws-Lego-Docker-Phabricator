FROM nginx:1.8.1

ARG phabricator_hash=f75b1cf562c0c3646324864851d693ef1069a068
ARG libphutil_hash=b8c65df2a910a7028d39bec602d181428b6ce01f
ARG arcanist_hash=01b6fe8bb0239a4bce03f58d6288a3a52ad83a91

RUN add-apt-repository ppa:git-core/ppa && \
    apt-get update -q && \
    apt-get install -y -q unzip curl sudo && \
    apt-get install -y -q git mercurial subversion python-pygments dpkg-dev && \
    apt-get install -y -q php5 php5-mysql php5-gd php5-dev php5-curl php-apc php5-cli php5-json php5-fpm
	
RUN mkdir /home/local && mkdir /home/local/storage
WORKDIR /home/local

RUN curl -o phabricator.zip -J -L https://github.com/phacility/phabricator/archive/$phabricator_hash.zip && \
    unzip -q phabricator.zip && rm phabricator.zip && mv ./phabricator-$phabricator_hash/ ./phabricator/
RUN curl -o libphutil.zip -J -L https://github.com/phacility/libphutil/archive/$libphutil_hash.zip && \
    unzip -q libphutil.zip && rm libphutil.zip && mv ./libphutil-$libphutil_hash/ ./libphutil/
RUN curl -o arcanist.zip -J -L https://github.com/phacility/arcanist/archive/$arcanist_hash.zip && \
    unzip -q arcanist.zip && rm arcanist.zip && mv ./arcanist-$arcanist_hash/ ./arcanist/

ADD ./phabricator.conf /etc/nginx/conf.d/default.conf
ADD ./init.sh ./

CMD ["/home/local/init.sh"]
