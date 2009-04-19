Feature: Lazy Run per Scenario
  In order to work with a single feature
  As a developer
  I want to skip the scenarios that don't need to be run
  
  Background:
    Given the cache is clear
    And I am using the simple example app
  
  Scenario: Change nothing and run same feature again
    Given I have run cucover features/call_foo_then_bar.feature
    When I run cucover features/call_foo_then_bar.feature
    Then it should pass with:
      """
      Feature: Call Foo then Bar


      [ Cucover - Skipping clean scenario ]
        Scenario: Call Foo # features/call_foo_then_bar.feature:3
          When I call Foo  # features/step_definitions/main_steps.rb:9


      [ Cucover - Skipping clean scenario ]
        Scenario: Call Bar # features/call_foo_then_bar.feature:6
          When I call Bar  # features/step_definitions/main_steps.rb:9

      2 scenarios
      2 skipped steps
      
      """
      
  Scenario: Edit source file covered by only one scenario and run same feature again
    Given I have run cucover features/call_foo_then_bar.feature
    When I edit the source file lib/foo.rb
    And I run cucover features/call_foo_then_bar.feature
    Then it should pass with:
      """
      Feature: Call Foo then Bar

        Scenario: Call Foo # features/call_foo_then_bar.feature:3
          When I call Foo  # features/step_definitions/main_steps.rb:9


      [ Cucover - Skipping clean scenario ]
        Scenario: Call Bar # features/call_foo_then_bar.feature:6
          When I call Bar  # features/step_definitions/main_steps.rb:9

      2 scenarios
      1 skipped step
      1 passed step
      
      """
  
  @in-progress
  Scenario: Run a feature with a background twice
    Given I have run cucover features/call_foo_from_background_then_bar.feature
    And I run cucover features/call_foo_from_background_then_bar.feature
    Then it should pass with:
      """
      Feature: Call Foo from Background then Bar

      
      [ Cucover - Skipping clean scenario ]
        Background:               # features/call_foo_from_background_then_bar.feature:3
          Given I have called Foo # features/step_definitions/main_steps.rb:5


      [ Cucover - Skipping clean scenario ]
        Scenario: Call Bar        # features/call_foo_from_background_then_bar.feature:6
          When I call Bar         # features/step_definitions/main_steps.rb:9

      1 scenario
      2 skipped steps
      
      """

  @in-progress
  Scenario: Edit source file covered by the background of a feature
    Given I have run cucover features/call_foo_from_background_then_bar.feature
    When I edit the source file lib/foo.rb
    And I run cucover features/call_foo_from_background_then_bar.feature
    Then it should pass with:
      """
      Feature: Call Foo from Background then Bar
      
        Background:               # features/call_foo_from_background_then_bar.feature:3
          Given I have called Foo # features/step_definitions/main_steps.rb:5


        Scenario: Call Bar        # features/call_foo_from_background_then_bar.feature:6
          When I call Bar         # features/step_definitions/main_steps.rb:9

      1 scenario
      2 passed steps
      
      """

  @in-progress
  Scenario: Edit source file covered by a scenario with a background
    Given I have run cucover features/call_foo_from_background_then_bar.feature
    When I edit the source file lib/bar.rb
    And I run cucover features/call_foo_from_background_then_bar.feature
    Then it should pass with:
      """
      Feature: Call Foo from Background then Bar then Baz
      
        Background:               # features/call_foo_from_background_then_bar.feature:3
          Given I have called Foo # features/step_definitions/main_steps.rb:5

        Scenario: Call Bar        # features/call_foo_from_background_then_bar.feature:6
          When I call Bar         # features/step_definitions/main_steps.rb:9


        [ Cucover - Skipping clean scenario ]
        Scenario: Call Baz        # features/call_foo_from_background_then_bar.feature:6
          When I call Baz        # features/step_definitions/main_steps.rb:9

      2 scenarios
      1 skipped step
      2 passed steps
      
      """
