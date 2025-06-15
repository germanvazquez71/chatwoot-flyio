FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn postgresql-client
RUN gem install bundler -v 2.5.16

RUN mkdir /app
WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

RUN yarn install --check-files
RUN bundle exec rake assets:precompile

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
