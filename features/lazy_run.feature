Feature: Lazy Run
  In order to get rapid feedback, stay motivated and keep my concentration
  As a developer
  I want to be able to run only the features that could have been affected by the changes I've made
  
  Background:
    Given I have run cucover features
  
  Scenario: Run nothing second time if nothing to do
    When I run cucover features
    Then it should pass with
      
  Scenario: Run run only one feature second time if source file touched
    When I edit the source file lib/bar.rb
    And I run cucover features
    Then it should pass with
      """
      features/call_foo_and_bar.feature
        features/step_definitions/main_steps.rb
        lib/foo.rb
        lib/bar.rb
  
      1 scenario
      2 passed steps
  
      """