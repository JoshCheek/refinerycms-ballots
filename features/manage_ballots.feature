@ballots
Feature: Ballots
  In order to have ballots on my website
  As an administrator
  I want to manage ballots

  Background:
    Given I am a logged in refinery user
    And I have no ballots

  @ballots-list @list
  Scenario: Ballots List
   Given I have ballots titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of ballots
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @ballots-valid @valid
  Scenario: Create Valid Ballot
    When I go to the list of ballots
    And I follow "Add New Ballot"
    And I fill in "Title" with "This is a test of the first string field"
    And I press "Save"
    Then I should see "'This is a test of the first string field' was successfully added."
    And I should have 1 ballot

  @ballots-invalid @invalid
  Scenario: Create Invalid Ballot (without title)
    When I go to the list of ballots
    And I follow "Add New Ballot"
    And I press "Save"
    Then I should see "Title can't be blank"
    And I should have 0 ballots

  @ballots-edit @edit
  Scenario: Edit Existing Ballot
    Given I have ballots titled "A title"
    When I go to the list of ballots
    And I follow "Edit this ballot" within ".actions"
    Then I fill in "Title" with "A different title"
    And I press "Save"
    Then I should see "'A different title' was successfully updated."
    And I should be on the list of ballots
    And I should not see "A title"

  @ballots-duplicate @duplicate
  Scenario: Create Duplicate Ballot
    Given I only have ballots titled UniqueTitleOne, UniqueTitleTwo
    When I go to the list of ballots
    And I follow "Add New Ballot"
    And I fill in "Title" with "UniqueTitleTwo"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 ballots

  @ballots-delete @delete
  Scenario: Delete Ballot
    Given I only have ballots titled UniqueTitleOne
    When I go to the list of ballots
    And I follow "Remove this ballot forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 ballots
 