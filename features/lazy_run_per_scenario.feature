Feature: Lazy Run per Scenario
  In order to work with a single feature
  As a developer
  I want to skip the scenarios that don't need to be run
  
  Background:
    Given the cache is clear
    And I am using the simple example app
    And I have run cucover features/call_foo_then_bar.feature
  
  Scenario: Change nothing and run same feature again
    When I run cucover features/call_foo_then_bar.feature
    Then it should pass with:
      """
      
      [ Cucover - Skipping clean feature ]
      [ Last run status: passed ]
      Feature: Call Foo then Bar

        Scenario: Call Foo # features/call_foo_then_bar.feature:3
          When I call Foo  # features/step_definitions/main_steps.rb:4

        Scenario: Call Bar # features/call_foo_then_bar.feature:6
          When I call Bar  # features/step_definitions/main_steps.rb:8

      2 scenarios
      2 skipped steps
      
      """
      
  @in-progress
  Scenario: Edit source file covered by only one scenario and run same feature again
    When I edit the source file lib/foo.rb
    And I run cucover features/call_foo_then_bar.feature
    Then it should pass with:
      """
      Feature: Call Foo
  
        Scenario: Call Foo # features/call_foo.feature:3
          When I call Foo  # features/step_definitions/main_steps.rb:4
  
      1 scenario
      1 passed step
      
      """
