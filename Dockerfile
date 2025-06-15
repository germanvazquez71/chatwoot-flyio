FROM ruby:3.2

# Instala dependencias del sistema
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev curl gnupg2 nodejs postgresql-client

# Instala Yarn 1.x manualmente (sin corepack)
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && apt-get install -y yarn

# Prepara directorio de la app
RUN mkdir /app
WORKDIR /app

# Copia Gemfile y Gemfile.lock para instalar gems
COPY Gemfile* ./
RUN bundle install

# Copia el resto de los archivos
COPY . .

# Instala paquetes JS con Yarn y compila assets
RUN yarn install
RUN bundle exec rake assets:precompile

# Comando para ejecutar Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
