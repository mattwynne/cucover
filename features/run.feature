Feature: Run
  In order to trust cucover and not have to switch between testing tools
  As a developer
  I want to be able to run features and get useful feedback through cucover
  
  Scenario: Run features, minimal output
    Given the cache is clear
    When I run cucover features/call_foo.feature features/call_foo_and_bar.feature
    Then it should pass with:
      """
      Feature: Call Foo

        Scenario: Call Foo # features/call_foo.feature:3
          When I call Foo  # features/step_definitions/main_steps.rb:4

      Feature: Call Foo and Bar

        Scenario: Call Foo # features/call_foo_and_bar.feature:3
          When I call Foo  # features/step_definitions/main_steps.rb:4
          And I call Bar   # features/step_definitions/main_steps.rb:8

      2 scenarios
      3 passed steps

      """
