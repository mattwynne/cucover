require 'rbconfig'

module Cucover
  BINARY        = File.expand_path(File.dirname(__FILE__) + '/../../bin/cucover')
  RUBY_BINARY   = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])
  CUCUMBER_LIB  = File.expand_path(File.dirname(__FILE__) + '/../../../cucumber/lib')
  LIB           = File.expand_path(File.dirname(__FILE__))
end