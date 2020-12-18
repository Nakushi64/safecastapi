# -*- encoding: utf-8 -*-
# stub: elastic-apm 3.6.0 ruby lib

Gem::Specification.new do |s|
  s.name = "elastic-apm".freeze
  s.version = "3.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "source_code_uri" => "https://github.com/elastic/apm-agent-ruby" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mikkel Malmberg".freeze]
  s.date = "2020-03-10"
  s.email = ["mikkel@elastic.co".freeze]
  s.homepage = "https://github.com/elastic/apm-agent-ruby".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "The official Elastic APM agent for Ruby".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<concurrent-ruby>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<http>.freeze, [">= 3.0"])
    else
      s.add_dependency(%q<concurrent-ruby>.freeze, ["~> 1.0"])
      s.add_dependency(%q<http>.freeze, [">= 3.0"])
    end
  else
    s.add_dependency(%q<concurrent-ruby>.freeze, ["~> 1.0"])
    s.add_dependency(%q<http>.freeze, [">= 3.0"])
  end
end
