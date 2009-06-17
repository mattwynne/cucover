Feature: Show Recordings
  In order to see what's going on inside Cucover
  As a developer of Cucover
  I want to be able to see a human-readable summary of the recordings

  Background:
    Given I am using the simple example app
  
  Scenario: Run a couple of features, see the recordings
    Given I have run cucover -- features/call_foo.feature
    And I have run cucover -- features/call_foo_and_bar_together.feature
    When I run cucover --show-recordings
    Then it should pass with:
    """

    features/call_foo.feature:3
      features/step_definitions/main_steps.rb:6:10
      lib/foo.rb:2:3:4
    
    features/call_foo_and_bar_together.feature:3
      lib/foo.rb:2:3:4
      features/step_definitions/main_steps.rb:6:10
      lib/bar.rb:2:3:4

    
    """