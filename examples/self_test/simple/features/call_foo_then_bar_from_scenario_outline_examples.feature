Feature: Call Foo then Bar from Scenario Outline Examples

  Scenario Outline: Call Something
    When I call <Code>
    
    Examples: 
      | Code |
      | Foo  |
      | Bar  |
