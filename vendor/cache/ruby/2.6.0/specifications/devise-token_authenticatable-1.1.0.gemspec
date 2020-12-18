# -*- encoding: utf-8 -*-
# stub: devise-token_authenticatable 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "devise-token_authenticatable".freeze
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sebastian Oelke".freeze]
  s.date = "2019-03-21"
  s.description = "This gem provides the extracted Token Authenticatable module of devise.\n                          It enables the user to sign in via an authentication token. This token\n                          can be given via a query string or HTTP Basic Authentication.".freeze
  s.email = ["dev@soelke.de".freeze]
  s.homepage = "https://github.com/baschtl/devise-token_authenticatable".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Provides authentication based on an authentication token for devise 3.2 and up.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<devise>.freeze, [">= 4.0.0", "< 5.0.0"])
      s.add_development_dependency(%q<rails>.freeze, ["~> 4.2"])
      s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<pry>.freeze, ["~> 0.10"])
      s.add_development_dependency(%q<factory_girl_rails>.freeze, ["~> 4.4"])
      s.add_development_dependency(%q<timecop>.freeze, ["~> 0.7"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.17"])
      s.add_development_dependency(%q<sqlite3>.freeze, ["~> 1.3.6"])
    else
      s.add_dependency(%q<devise>.freeze, [">= 4.0.0", "< 5.0.0"])
      s.add_dependency(%q<rails>.freeze, ["~> 4.2"])
      s.add_dependency(%q<rspec-rails>.freeze, ["~> 3.0"])
      s.add_dependency(%q<pry>.freeze, ["~> 0.10"])
      s.add_dependency(%q<factory_girl_rails>.freeze, ["~> 4.4"])
      s.add_dependency(%q<timecop>.freeze, ["~> 0.7"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.17"])
      s.add_dependency(%q<sqlite3>.freeze, ["~> 1.3.6"])
    end
  else
    s.add_dependency(%q<devise>.freeze, [">= 4.0.0", "< 5.0.0"])
    s.add_dependency(%q<rails>.freeze, ["~> 4.2"])
    s.add_dependency(%q<rspec-rails>.freeze, ["~> 3.0"])
    s.add_dependency(%q<pry>.freeze, ["~> 0.10"])
    s.add_dependency(%q<factory_girl_rails>.freeze, ["~> 4.4"])
    s.add_dependency(%q<timecop>.freeze, ["~> 0.7"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.17"])
    s.add_dependency(%q<sqlite3>.freeze, ["~> 1.3.6"])
  end
end
