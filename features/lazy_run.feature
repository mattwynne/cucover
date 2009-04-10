Feature: Lazy Run
  In order to get rapid feedback, stay motivated and keep my concentration
  As a developer
  I want to be able to run only the features that could have been affected by the changes I've made
  
  Background:
    Given the cache is clear
    And I am using the simple example app
    And I have run cucover features/call_foo.feature
  
  Scenario: Change nothing and run cucover again
    When I run cucover features/call_foo.feature
    Then it should pass with:
      """
      0 scenarios
      
      """
      
  Scenario: Touch feature file and run cucover again
    When I edit the source file features/call_foo.feature
    And I run cucover features/call_foo.feature
    Then it should pass with:
      """
      Feature: Call Foo

        Scenario: Call Foo # features/call_foo.feature:3
          When I call Foo  # features/step_definitions/main_steps.rb:4

      1 scenario
      1 passed step
      
      """
  
  Scenario: Touch one source file and cucover against lots of features
    When I edit the source file lib/bar.rb
    And I run cucover features/*foo*.feature
    Then it should pass with:
      """
      Feature: Call Foo and Bar

        Scenario: Call Foo # features/call_foo_and_bar.feature:3
          When I call Foo  # features/step_definitions/main_steps.rb:4
          And I call Bar   # features/step_definitions/main_steps.rb:8

      1 scenario
      2 passed steps
      
      """