Feature: Lazy Run
  In order to get rapid feedback, stay motivated and keep my concentration
  As a developer
  I want to be able to run only the features that could have been affected by the changes I've made
  
  Background:
    And I am using the simple example app
    And I have run cucover -- features/call_foo.feature
  
  Scenario: Change nothing and run same feature again
    When I run cucover -- -q features/call_foo.feature
    Then it should pass with:
      """
      Feature: Call Foo

        Scenario: Call Foo
      
      [ Cucover - Skipping clean scenario ]
          When I call Foo
      
      1 scenario (1 skipped)
      1 step (1 skipped)
      
      """
      
  Scenario: Change irrelevant source file and run same feature again
    When I edit the source file lib/bar.rb
    When I run cucover -- features/call_foo.feature
    Then it should pass with:
      """
      Feature: Call Foo
      
        Scenario: Call Foo # features/call_foo.feature:3

      [ Cucover - Skipping clean scenario ]
          When I call Foo  # features/step_definitions/main_steps.rb:9
      
      1 scenario (1 skipped)
      1 step (1 skipped)
      
      """  
      
  Scenario: Touch feature file and run same feature again
    When I edit the source file features/call_foo.feature
    And I run cucover -- features/call_foo.feature
    Then it should pass with:
      """
      Feature: Call Foo

        Scenario: Call Foo # features/call_foo.feature:3
          When I call Foo  # features/step_definitions/main_steps.rb:9

      1 scenario (1 passed)
      1 step (1 passed)
      
      """
  
  Scenario: Touch one source file and try to run lots of features
    When I edit the source file lib/bar.rb
    And I run cucover -- features/call_foo.feature features/call_foo_and_bar_together.feature
    Then it should pass with:
      """
      Feature: Call Foo
      
        Scenario: Call Foo # features/call_foo.feature:3
      
      [ Cucover - Skipping clean scenario ]
          When I call Foo  # features/step_definitions/main_steps.rb:9
      
      Feature: Call Foo and Bar Together

        Scenario: Call Foo and Bar # features/call_foo_and_bar_together.feature:3
          When I call Foo          # features/step_definitions/main_steps.rb:9
          And I call Bar           # features/step_definitions/main_steps.rb:9

      2 scenarios (1 skipped, 1 passed)
      3 steps (1 skipped, 2 passed)
      
      """
