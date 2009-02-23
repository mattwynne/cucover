Feature: Run
  In order to trust cucover and not have to switch between testing tools
  As a developer
  I want to be able to run features and get useful feedback through cucover
  
  Scenario: Run features, minimal output
    When I run cucover features/call_foo.feature features/call_foo_and_bar.feature
    Then it should pass with
      """

      Coverage
      --------

      features/call_foo.feature
        features/step_definitions/main_steps.rb
        lib/foo.rb
      features/call_foo_and_bar.feature
        features/step_definitions/main_steps.rb
        lib/bar.rb
        lib/foo.rb

      2 scenarios
      3 passed steps

      
      """
