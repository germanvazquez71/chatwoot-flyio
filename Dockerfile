FROM ruby:3.2-slim AS build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl build-essential git \
    libpq-dev libvips libffi-dev libyaml-dev imagemagick \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g corepack

WORKDIR /app
COPY . .

RUN corepack enable \
    && corepack prepare pnpm@9.7.0 --activate

RUN gem install bundler \
    && bundle config set without 'development test' \
    && bundle install

RUN pnpm install --frozen-lockfile
RUN pnpm run build

FROM ruby:3.2-slim AS final
RUN apt-get update && apt-get install -y --no-install-recommends libpq-dev libvips imagemagick && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=build /app /app
EXPOSE 3000
ENV RAILS_ENV=production RAILS_LOG_TO_STDOUT=true
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
