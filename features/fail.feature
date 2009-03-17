Feature: Fail
  In order to diagnose a fault
  As a developer
  I want to get useful information when a feature fails
  
  Scenario: Two features, one fails
    Given the cache is clear
    When I run cucover features/call_foo.feature features/fail.feature
    Then it should fail with:
      """
      Feature: Call Foo
        In order to get foo done
        As a test app
        I want to do the foo
      
        Scenario: Call Foo # features/call_foo.feature:6
          When I call Foo  # features/step_definitions/main_steps.rb:4
      
      Feature: Epic Fail
        In order to make my job look really hard
        As a developer
        I want tests to fail from time to time
      
        Scenario: Do something stupid # features/fail.feature:6
          When I divide by zero       # features/step_definitions/main_steps.rb:12
            divided by 0 (ZeroDivisionError)
            ./features/step_definitions/main_steps.rb:13:in `/'
            ./features/step_definitions/main_steps.rb:13:in `/^I divide by zero$/'
            features/fail.feature:7:in `When I divide by zero'
      
      2 scenarios
      1 failed step
      1 passed step
      
      """
  

  
