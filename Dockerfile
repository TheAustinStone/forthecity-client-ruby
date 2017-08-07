FROM ruby:2.4

MAINTAINER Joseph Simmons 'joseph@austinstone.org'
ENV REFRESHED 2017-08-07
RUN gem install bundler --no-ri --no-rdoc
VOLUME ['/opt/app']
ADD . /opt/app/
WORKDIR /opt/app
RUN bundle install
