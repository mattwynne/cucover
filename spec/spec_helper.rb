require 'rubygems'
gem 'rspec'
require 'spec'
require 'spec/mocks/framework'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'cucover'
