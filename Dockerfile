FROM ruby:3.2

# Instala dependencias del sistema
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs curl postgresql-client

# Habilita Corepack y prepara Yarn 1.22.22 (compatible con Chatwoot)
RUN corepack enable && corepack prepare yarn@1.22.22 --activate

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
