# ---------------------------
# Builder Stage
# ---------------------------
FROM ruby:3.1.3-slim AS builder

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  bash ca-certificates curl gnupg \
  build-essential libpq-dev \
  git \
  shared-mime-info \
  && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y --no-install-recommends nodejs \
  && npm install -g yarn \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.4.10 \
  && bundle config set deployment 'true' \
  && bundle install --jobs 10 --retry 3 --verbose

COPY . .

# Precompile assets
ENV RAILS_ENV=production \
    RACK_ENV=production
RUN bundle exec rails assets:precompile

# ---------------------------
# Final Stage
# ---------------------------
FROM ruby:3.1.3-slim

LABEL maintainer="Kakada CHHEANG <kakada@kawsang.com>"

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  nodejs \
  ca-certificates \
  libpq5 \
  wkhtmltopdf xfonts-75dpi xfonts-base fontconfig \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

# Bundler environment
ENV BUNDLE_PATH=/usr/local/bundle \
    GEM_HOME=/usr/local/bundle \
    GEM_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test \
    RAILS_ENV=production \
    RACK_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true

# Copy gems and app from builder
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

# Register custom fonts for PDF rendering
RUN mkdir -p /usr/share/fonts/truetype/custom \
  && if [ -d /app/vendor/assets/fonts ]; then cp -a /app/vendor/assets/fonts/. /usr/share/fonts/truetype/custom/; fi \
  && fc-cache -f -v

# Config
COPY docker/database.yml /app/config/database.yml

EXPOSE 80

CMD ["bundle", "exec", "puma", "-e", "production", "-b", "tcp://0.0.0.0:80"]
