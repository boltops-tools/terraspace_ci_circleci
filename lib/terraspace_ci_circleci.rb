# frozen_string_literal: true

require "terraspace_ci_circleci/autoloader"
TerraspaceCiCircleci::Autoloader.setup

require "json"

module TerraspaceCiCircleci
  class Error < StandardError; end
end

Terraspace::Cloud::Ci.register(
  name: "circleci",
  env_key: "CIRCLECI",
  root: __dir__,
  exe: ".circleci/bin", # terraspace new ci NAME generator will make files in this folder executable
)
