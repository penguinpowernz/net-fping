#coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "net-fping"
  spec.version       = "0.3.2"
  spec.authors       = ["Robert McLeod"]
  spec.email         = ["robert@penguinpower.co.nz"]
  spec.description   = %q{Net-fping is an fping wrapper that allows fast ping checks on multiple remote hosts}
  spec.summary       = %q{fast ping checks using fping}
  spec.homepage      = "https://github.com/penguinpowernz/net-fping"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]
end
