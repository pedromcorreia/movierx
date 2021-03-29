FROM ruby:2.6.3-alpine3.10

RUN apk add build-base
RUN apk add --update --no-cache \
        build-base \
        postgresql-dev \
        vim \
        tzdata \
        bash \
        less \
        --no-cache \
        nodejs \
        yarn

RUN mkdir /movierx

WORKDIR /movierx

ADD Gemfile /movierx/Gemfile
ADD Gemfile.lock /movierx/Gemfile.lock
RUN gem update --system \
        && gem install bundler -v 2.1.4 \
        && gem install pg -v '1.2.2' --source 'https://rubygems.org/' \
        && bundle install -j 4

RUN yarn install --check-files

RUN bundle install
ADD . /movierx
