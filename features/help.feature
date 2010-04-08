Feature: Showing help
  In order to harness the full power of cucover
  As a developer
  I want to see help explaining cucovers usage
  
  Background:
    Given I am using the simple example app
  
  Scenario: --help
    When I run cucover --help
    Then I should see "Usage: cucover -- [options] [ [FILE|DIR|URL][:LINE[:LINE]*] ]+"
  
  Scenario: invalid command line handle
    When I run cucover --invalid-thingy
    Then I should see "Usage: cucover -- [options] [ [FILE|DIR|URL][:LINE[:LINE]*] ]+"
