Feature: Coverage Of
  In order to find out how well tested a source file that I'm working on is
  As a developer
  I want to be able to ask Cucover which features cover which lines of a given source file

  Background:
    Given I am using the simple example app

  Scenario: Get coverage of a source file that's partly touched by the feature that was run
    Given I have run cucover -- features/call_foo.feature
    When I run cucover --coverage-of lib/foo.rb
    Then it should pass with:
    """
    1 class Foo
    2   def execute     features/call_foo.feature:3
    3     true          features/call_foo.feature:3
    4   end
    5
    6   def sloppy_me..
    7     1/0
    8   end
    9 end

    """

  Scenario: Run another feature that also covers the same source file
    Given I have run cucover -- features/call_foo.feature
    And I have run cucover -- features/call_foo_and_bar_together.feature
    When I run cucover --coverage-of lib/foo.rb
    Then it should pass with:
    """
    1 class Foo
    2   def execute     features/call_foo_and_bar_together.feature:3, features/call_foo.feature:3
    3     true          features/call_foo_and_bar_together.feature:3, features/call_foo.feature:3
    4   end
    5
    6   def sloppy_me..
    7     1/0
    8   end
    9 end

    """


