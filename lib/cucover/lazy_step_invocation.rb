module Cucover
  module LazyStepInvocation
    def accept(visitor)
      skip_invoke! if Cucover.can_skip?
      super
    end

    def failed(exception, clear_backtrace)
      Cucover.fail_current_test!
      super
    end
  end
end
