module Cucover
  module Rails
    class << self
      def patch_if_necessary
        return if @patched
        return unless defined?(ActionView)
      
        Monkey.extend_every ActionView::Base => Cucover::Rails::RecordsRenders
        # Monkey.extend_every ActionView::Template => Cucover::Rails::RecordsRenders # TODO: patch nicer template
        
        @patched = true
      end
    end
  
    module RecordsRenders
      def render(*args)
        filename = args[0][:file].filename
        Cucover.record_file(filename)
        super
      end
    end
  end
end
