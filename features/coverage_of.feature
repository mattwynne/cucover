Feature: Coverage Of
  In order to find out how well tested a source file that I'm working on is
  As a developer
  I want to be able to ask Cucover which features cover which lines of a given source file
  
  Background:
    Given the cache is clear
    And I am using the simple example app
    And I have run cucover -- features/call_foo.feature

  Scenario: Run a feature that covers only some of the source code in a file
    When I run cucover --coverage-of lib/foo.rb
    Then it should pass with:
    """
    1                           class Foo
    2 features/call_foo.feature   def execute
    3 features/call_foo.feature     true
    4 features/call_foo.feature   end
    5                           
    6                             def sloppy_method
    7                               1/0
    8                             end
    9                           end
    
    """
    
  
