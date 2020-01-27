FROM ruby:2.7

RUN apt-get update

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -yq nodejs

# Install Ruby & related dependencies
RUN apt-get install -yq ruby ruby-dev build-essential git
RUN gem install --no-document bundler:1.10.6

# Set working direcotry
ENV INSTALL_PATH /app
WORKDIR $INSTALL_PATH

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
ADD Gemfile* $INSTALL_PATH/
ENV BUNDLE_GEMFILE=$INSTALL_PATH/Gemfile BUNDLE_JOBS=2 BUNDLE_PATH=/bundle

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . .

# Update bundler to latest version and run the install
RUN bundle install

#EXPOSE 4567

CMD ["bundle", "exec", "middleman", "server"]
