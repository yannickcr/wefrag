klass = ScottBarron::Acts::StateMachine::InstanceMethods
klass.module_eval do
  def run_transition_action(action)
    Symbol === action ? self.method(action).untaint.call : action.call(self)
  end
end
