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
      0 scenarios
      
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
