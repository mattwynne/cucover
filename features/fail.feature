Feature: Fail
  In order to diagnose a fault
  As a developer
  I want to get useful information when a feature fails
  
  Scenario: Two features, one fails
    Given the cache is clear
    When I run cucover features/call_foo.feature features/fail.feature
    Then it should fail with:
      """

      Coverage
      --------

      features/call_foo.feature
        features/step_definitions/main_steps.rb
        lib/foo.rb
      features/fail.feature
        features/step_definitions/main_steps.rb

      2 scenarios
      1 failed step
      1 passed step

      features/fail.feature:6

      """
  

  
