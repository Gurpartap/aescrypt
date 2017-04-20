# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Gurpartap Singh", "Charcoal"]
  gem.email         = ["contact@gurpartap.com", "art@charcoal-se.org"]
  gem.description   = "Simple AES encryption / decryption for Ruby"
  gem.summary       = "AESCrypt is a simple to use, opinionated AES encryption / decryption Ruby gem that just works."
  gem.homepage      = "http://github.com/Gurpartap/aescrypt"
  gem.licenses      = ['MIT']

  gem.files         = Dir.glob("lib/**/*")
  gem.name          = "aescrypt"
  gem.require_paths = ["lib"]
  gem.version       = "2.0.2"

  gem.add_development_dependency "rake"
end
