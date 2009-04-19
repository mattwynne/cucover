Feature: Call Foo from Background then Bar then Baz

  Background:
    Given I have called Foo

  Scenario: Call Bar
    When I call Bar

  Scenario: Call Baz
    When I call Baz
