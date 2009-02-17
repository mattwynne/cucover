Feature: Run
  In order to save time when running features
  As a developer
  I want to be able to run only the features that could have been affected by the changes I've made
  
  Scenario: Run all features first time
    When I run cucover features
    Then I it should pass with
      """
      features/call_foo.feature
        lib/foo.rb
      features/call_foo_and_bar.feature
        lib/bar.rb
        lib/foo.rb
      
      2 scenarios
      3 passed steps
      
      """
