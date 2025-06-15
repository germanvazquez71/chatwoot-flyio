FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn postgresql-client
RUN gem install bundler -v 2.5.16

RUN mkdir /app
WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .
# Instala Yarn de forma oficial
RUN corepack enable && corepack prepare yarn@3.6.4 --activate

RUN yarn install
RUN bundle exec rake assets:precompile

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
