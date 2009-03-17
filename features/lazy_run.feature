Feature: Lazy Run
  In order to get rapid feedback, stay motivated and keep my concentration
  As a developer
  I want to be able to run only the features that could have been affected by the changes I've made
  
  Background:
    Given the cache is clear
    And I have run cucover features/call_foo.feature
  
  Scenario: Run nothing second time if nothing to do
    When I run cucover features/call_foo.feature
    Then it should pass with:
      """
      0 scenarios
      
      """

  Scenario: Run run only one feature second time if source file touched
    When I edit the source file lib/bar.rb
    And I run cucover features/*foo*.feature
    Then it should pass with:
      """
      Feature: Call Foo and Bar
        In order to get foo and bar done
        As a test app
        I want to do the foo and the bar together

        Scenario: Call Foo # features/call_foo_and_bar.feature:6
          When I call Foo  # features/step_definitions/main_steps.rb:4
          And I call Bar   # features/step_definitions/main_steps.rb:8

      1 scenario
      2 passed steps
      
      """