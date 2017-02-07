# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ThePolicy/version'

Gem::Specification.new do |spec|
  spec.name          = "ThePolicy"
  spec.version       = ThePolicy::VERSION
  spec.authors       = ["oTsogbadrakhChinzorig"]
  spec.email         = ["tsogbadrakh@globalsign.com"]

  spec.summary       = %q{ Authization of Rails }
  spec.description   = %q{ Authization of Rails }
  spec.homepage      = "https://github.com/oTsogbadrakhChinzorig/ThePolicy"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://localhost'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency 'multi_json'
  spec.add_dependency 'the_string_to_slug', '~> 1.4'
  spec.add_runtime_dependency 'rails', ['>= 3.2', '< 6']
end
