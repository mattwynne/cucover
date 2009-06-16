@slow
Feature: Lazy Run Triggered By Rails View Change
  In order to feel the cucover love
  As a front-end developer
  I want the changes I make to rails views to trigger cucover runs, the same as Ruby code does
  
  Background:
    Given the cache is clear
    And I am using the rails example app
    And I have run cucover -- features/see_widgets.feature

  Scenario: Change nothing and run cucover again
    When I run cucover -- features/see_widgets.feature
    Then it should pass with:
      """
      Feature: See widgets


      [ Cucover - Skipping clean scenario ]
        Scenario: See widgets                                  # features/see_widgets.feature:3
          When I go to /widgets                                # features/step_definitions/webrat_steps.rb:1
          Then I should see "Look at all these lovely widgets" # features/step_definitions/webrat_steps.rb:5

      1 scenario (1 skipped)
      2 steps (2 skipped)
      
      """
      
  Scenario: Edit a view and run cucover again
    When I edit the source file app/views/widgets/index.html.erb
    When I run cucover -- features/see_widgets.feature
    Then it should pass with:
      """
      Feature: See widgets

        Scenario: See widgets                                  # features/see_widgets.feature:3
          When I go to /widgets                                # features/step_definitions/webrat_steps.rb:1
          Then I should see "Look at all these lovely widgets" # features/step_definitions/webrat_steps.rb:5

      1 scenario (1 passed)
      2 steps (2 passed)
      
      """