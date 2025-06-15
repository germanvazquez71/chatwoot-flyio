FROM ruby:3.2

# Instalar dependencias del sistema
RUN apt-get update -qq && apt-get install -y \
    build-essential libpq-dev postgresql-client curl gnupg

# Instalar Node.js + npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Instalar Yarn
RUN npm install -g yarn@1.22.22

# Crear y entrar al directorio de la app
RUN mkdir /app
WORKDIR /app

# Instalar gemas
COPY Gemfile* ./
RUN bundle install

# Copiar el resto del código
COPY . .

# Instalar paquetes JS
RUN yarn install

# Precompilar assets
RUN bundle exec rake assets:precompile

# Iniciar servidor
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
