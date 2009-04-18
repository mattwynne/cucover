module Cucover
  module Monkey
    def self.extend_every(args)
      class_to_extend = args.keys.first
      module_to_extend_with = args.values.first
    
      class_to_extend.instance_eval <<-PATCH
        def new(*args)
          super(*args).extend(#{module_to_extend_with})
        end
      PATCH
    end
  end
end