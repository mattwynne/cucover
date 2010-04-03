require 'rbconfig'

module Cucover
  module LineNumbers
    # Different Ruby versions have slightly different line numbers with rcov
    def self.offset
      Config::CONFIG['MINOR'] == '9' ? 0 : 1
    end
  end
end
