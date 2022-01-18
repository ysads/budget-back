FROM ruby:2.7.1-alpine

RUN apk add --update git \
  build-base \
  postgresql-client \
  postgresql-dev

RUN mkdir /web
WORKDIR /web
COPY . /web

RUN bundle install

ENTRYPOINT [ "./bin/run.sh" ]
