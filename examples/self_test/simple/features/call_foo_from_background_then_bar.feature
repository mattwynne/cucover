Feature: Call Foo from Background then Bar

  Background:
    Given I have called Foo

  Scenario: Call Bar
    When I call Bar
