Feature: Lazy Run per Scenario Outline Example
  In order save time
  As a developer working on a feature with Scenario Outlines
  I want to run only the examples that could fail
  
  Background:
    Given I am using the simple example app
    And I have run cucover -- features/call_foo_then_bar_from_scenario_outline_examples.feature
  
  Scenario: Edit a source file that should trigger just one of the examples to be run
    When I edit the source file lib/bar.rb
    And I run cucover -- -q features/call_foo_then_bar_from_scenario_outline_examples.feature
    Then it should pass with:
      """
      Feature: Call Foo then Bar from Scenario Outline Examples

        Scenario Outline: Call Something
          When I call <Code>

          Examples: 
            | Code |
            |
      [ Cucover - Skipping clean scenario ]
       Foo  |
            | Bar  |

      2 scenarios (1 skipped, 1 passed)
      2 steps (1 skipped, 1 passed)
      
      """
    # Which is a bit ugly, but that's down the the formatter
