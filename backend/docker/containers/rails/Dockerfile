FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y build-essential default-libmysqlclient-dev nodejs

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 744 /usr/local/bin/docker-entrypoint.sh

WORKDIR /app
ENTRYPOINT ["docker-entrypoint.sh"]
