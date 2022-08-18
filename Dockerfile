# docker build . -t boostnote_converter
# docker run -it --rm -v "$PWD:/app" -w "/app" boostnote_convertor

# For testing, use the conversions/ directory.

FROM ruby:3.0.0

RUN wget "https://github.com/jgm/pandoc/releases/download/2.12/pandoc-2.12-1-amd64.deb" \
      && dpkg -i "pandoc-2.12-1-amd64.deb"

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /app

COPY Gemfile Gemfile.lock *.gemspec ./
RUN bundle install

COPY . .

CMD ["/bin/bash"]
