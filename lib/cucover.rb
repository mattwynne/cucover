$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'cucover/platform'

$:.unshift(Cucover::CUCUMBER_LIB) unless
    $:.include?(Cucover::CUCUMBER_LIB) || $:.include?(File.expand_path(Cucover::CUCUMBER_LIB))

module Cucover
end