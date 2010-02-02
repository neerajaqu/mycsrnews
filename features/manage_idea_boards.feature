Feature: Manage idea_boards
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Register new idea_board
    Given I am on the new idea_board page
    And I press "Create"

  Scenario: Delete idea_board
    Given the following idea_boards:
      ||
      ||
      ||
      ||
      ||
    When I delete the 3rd idea_board
    Then I should see the following idea_boards:
      ||
      ||
      ||
      ||
