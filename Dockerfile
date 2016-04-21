FROM ruby:1.9.3

MAINTAINER Joseph Simmons 'joseph@austinstone.org'
ENV REFRESHED 2016-04-19
RUN apt-get -y update
RUN apt-get -y dist-upgrade
RUN apt-get install -y ruby-rspec git
RUN gem install rubygems-update --no-ri --no-rdoc
RUN update_rubygems
RUN gem install bundler sinatra --no-ri --no-rdoc
VOLUME ['/opt/app']

ADD ./* '/opt/app/'
WORKDIR '/opt/app'
RUN bundle install --verbose
