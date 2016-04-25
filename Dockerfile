FROM ruby:1.9

MAINTAINER Joseph Simmons 'joseph@austinstone.org'
ENV REFRESHED 2016-04-25
RUN gem install bundler --no-ri --no-rdoc
VOLUME ['/opt/app']
ADD . /opt/app/
WORKDIR /opt/app
RUN bundle install
