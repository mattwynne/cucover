module Cucover
  module Rails
    class << self
      def patch_if_necessary
        return if @patched
        return unless defined?(ActionView)
      
        Monkey.extend_every ActionView::Template => Cucover::Rails::RecordsRenders
      
        @patched = true
      end
    end
  
    module RecordsRenders
      def render
        Cucover::Recording.record_file(@filename)
        super
      end
    end
  end
end
