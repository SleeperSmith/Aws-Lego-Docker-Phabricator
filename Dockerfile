FROM nginx:1.8.1

RUN apt-get update && \
    apt-get install -y unzip curl && \
    apt-get install -y -q git mercurial subversion apache2 dpkg-dev && \
    apt-get install -y -q php5 php5-mysql php5-gd php5-dev php5-curl php-apc php5-cli php5-json
	
RUN mkdir /home/local
WORKDIR /home/local

RUN curl -o phabricator.zip -J -L https://github.com/phacility/phabricator/archive/f75b1cf562c0c3646324864851d693ef1069a068.zip && \
    unzip phabricator.zip && rm phabricator.zip
