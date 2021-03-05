FROM ruby:3.0.0

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /app

COPY Gemfile Gemfile.lock *.gemspec ./
RUN bundle install

COPY . .

CMD ["/bin/bash"]
