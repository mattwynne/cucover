Feature: Run
  In order to trust cucover and not have to switch between testing tools
  As a developer
  I want to be able to run features and get useful feedback through cucover
  
  Scenario: Run all features first time
    When I run cucover features
    Then it should pass with
      """
      features/call_foo.feature
        features/step_definitions/main_steps.rb
        lib/foo.rb
      features/call_foo_and_bar.feature
        features/step_definitions/main_steps.rb
        lib/foo.rb
        lib/bar.rb
      
      2 scenarios
      3 passed steps
      
      """
