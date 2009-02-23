Feature: Lazy Run
  In order to get rapid feedback, stay motivated and keep my concentration
  As a developer
  I want to be able to run only the features that could have been affected by the changes I've made
  
  Background:
    Given the cache is clear
    And I have run cucover features/call_foo.feature
  
  Scenario: Run nothing second time if nothing to do
    When I run cucover features/call_foo.feature
    Then it should pass with no response

  Scenario: Run run only one feature second time if source file touched
    When I edit the source file lib/bar.rb
    And I run cucover features/*foo*.feature
    Then it should pass with:
      """
      
      Coverage
      --------
      
      features/call_foo.feature
      features/call_foo_and_bar.feature
        features/step_definitions/main_steps.rb
        lib/bar.rb
        lib/foo.rb
  
      1 scenario
      2 passed steps
  
      """