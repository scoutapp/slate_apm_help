require 'middleman-gh-pages'

DOCKER_IMAGE_NAME = "scout-apm-help"
DOCKER_IMAGE_VERSION = "latest"
DOCKER_IMAGE_FULL_NAME = "#{DOCKER_IMAGE_NAME}:#{DOCKER_IMAGE_VERSION}"

MIDDLMEAN_PORT = 4567
LIVERELOAD_PORT = 35729

desc "Build docker image"
task "docker:image:build" do |t, args|
  sh "docker build -t #{DOCKER_IMAGE_NAME} ."
end

desc "Run docker image"
task "docker:image:run" do |t, args|
  sh "docker run --rm" \
     " -p #{MIDDLEMAN_PORT}:#{MIDDLEMANPORT}" \
     " --name #{DOCKER_IMAGE_NAME}" \
     " #{DOCKER_IMAGE_FULL_NAME}"
end

desc "Run docker image for development"
task "docker:image:dev" do |t, args|
  sh "docker run --rm" \
     " -p #{MIDDLEMAN_PORT}:#{MIDDLEMANPORT}" \
     " -p #{LIVERELOAD_PORT}:#{LIVERELOAD_PORT}" \
     # Set env and volume in local files so middleman will change on the fly
     " -e MIDDLEMAN_LIVE_RELOAD=true" \
     " -v $(pwd)/source/includes:/app/source/includes" \
     " --name #{DOCKER_IMAGE_NAME}" \
     " #{DOCKER_IMAGE_FULL_NAME}"
end
