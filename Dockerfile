ARG RUBY_VERSION=3.1.3
FROM ruby:$RUBY_VERSION AS builder

# Install packages
RUN apt-get update -qq && \
    apt-get install -y build-essential libffi-dev tzdata postgresql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Install JavaScript dependencies
ARG NODE_VERSION=20.5.1
ARG YARN_VERSION=1.22.19
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

# Work directory
WORKDIR /rails

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile --gemfile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

FROM ruby:$RUBY_VERSION

WORKDIR /rails

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

COPY --from=builder /rails .

# Set production environment
ARG RAILS_ENV
ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_ENV="production" \
    SECRET_KEY_BASE_DUMMY="1"
# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["bundle", "exec", "puma"]