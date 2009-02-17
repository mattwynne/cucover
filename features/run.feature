Feature: Run
  In order to save time when running features
  As a developer
  I want to be able to run only the features that could have been affected by the changes I've made
  
  Scenario: Run all features first time
    When I run cucover features
    Then it should pass with
      """
      features/call_foo.feature
        features/step_definitions/main_steps.rb
        lib/foo.rb
      features/call_foo_and_bar.feature
        features/step_definitions/main_steps.rb
        lib/foo.rb
        lib/bar.rb
      
      2 scenarios
      3 passed steps
      
      """

  Scenario: Run nothing second time if nothing to do
    Given I have run cucover features
    And I run cucover features
    Then it should pass with
      
  Scenario: Run run only one feature second time if source file touched
    Given I have run cucover features
    And I edit the source file lib/bar.rb
    When I run cucover features
    Then it should pass with
      """
      features/call_foo_and_bar.feature
        features/step_definitions/main_steps.rb
        lib/foo.rb
        lib/bar.rb
  
      1 scenario
      2 passed steps
  
      """