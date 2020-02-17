require 'middleman-gh-pages'

DOCKER_IMAGE_NAME="scout-apm-help"
DOCKER_IMAGE_VERSION="latest"
DOCKER_IMAGE_FULL_NAME="#{DOCKER_IMAGE_NAME}:#{DOCKER_IMAGE_VERSION}"

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
