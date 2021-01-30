FROM ruby:2.6
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       apt-transport-https \
                       libpq-dev \
                       postgresql-client \
                       --no-install-recommends \
                       vim

# node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get install -y nodejs


# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" \
    | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn \
    && yarn install --check-files

RUN mkdir /webapp
WORKDIR /webapp
COPY Gemfile /webapp
COPY Gemfile.lock /webapp

RUN bundle install

RUN rm -f /webapp/tmp/pids/server.pid
