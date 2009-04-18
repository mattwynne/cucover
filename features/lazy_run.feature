Feature: Lazy Run
  In order to get rapid feedback, stay motivated and keep my concentration
  As a developer
  I want to be able to run only the features that could have been affected by the changes I've made
  
  Background:
    Given the cache is clear
    And I am using the simple example app
    And I have run cucover features/call_foo.feature
  
  Scenario: Change nothing and run same feature again
    When I run cucover features/call_foo.feature
    Then it should pass with:
      """
      
      [ Cucover - Skipping clean feature ]
      [ Last run status: passed ]
      Feature: Call Foo
      
        Scenario: Call Foo # features/call_foo.feature:3
          When I call Foo  # features/step_definitions/main_steps.rb:4
      
      1 scenario
      1 skipped step
      
      """
      
  Scenario: Touch feature file and run same feature again
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
  
  Scenario: Touch one source file and try to run lots of features
    When I edit the source file lib/bar.rb
    And I run cucover features/call_foo.feature features/call_foo_and_bar_together.feature
    Then it should pass with:
      """
      
      [ Cucover - Skipping clean feature ]
      [ Last run status: passed ]
      Feature: Call Foo
      
        Scenario: Call Foo # features/call_foo.feature:3
          When I call Foo  # features/step_definitions/main_steps.rb:4
      
      Feature: Call Foo and Bar Together

        Scenario: Call Foo and Bar # features/call_foo_and_bar_together.feature:3
          When I call Foo          # features/step_definitions/main_steps.rb:4
          And I call Bar           # features/step_definitions/main_steps.rb:8

      2 scenarios
      1 skipped step
      2 passed steps
      
      """