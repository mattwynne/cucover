Feature: Run
  In order to trust cucover and not have to switch between testing tools
  As a developer
  I want to be able to run features and get useful feedback through cucover

  Scenario: Run features, minimal output
    Given I am using the simple example app
    When I run cucover -- features/call_foo.feature features/call_foo_and_bar_together.feature
    Then it should pass with:
      """
      Feature: Call Foo

        Scenario: Call Foo # features/call_foo.feature:3
          When I call Foo  # features/step_definitions/main_steps.rb:9

      Feature: Call Foo and Bar Together

        Scenario: Call Foo and Bar # features/call_foo_and_bar_together.feature:3
          When I call Foo          # features/step_definitions/main_steps.rb:9
          And I call Bar           # features/step_definitions/main_steps.rb:9

      2 scenarios (2 passed)
      3 steps (3 passed)

      """
