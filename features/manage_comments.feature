Feature: Manage comments
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Register new comment
    Given I am on the new comment page
    When I fill in "Comments" with "comments 1"
    And I press "Create"
    Then I should see "comments 1"

  Scenario: Delete comment
    Given the following comments:
      |comments|
      |comments 1|
      |comments 2|
      |comments 3|
      |comments 4|
    When I delete the 3rd comment
    Then I should see the following comments:
      |Comments|
      |comments 1|
      |comments 2|
      |comments 4|
