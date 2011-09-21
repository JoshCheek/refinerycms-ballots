@login-to-vote
Feature: Login to vote

  Background:
    Given I have no ballots, offices, or candidates
    And a ballot with multiple offices and candidates
    And a member "A123"

  Scenario: Cannot bypass login
    When I go to the new vote page
    Then I am redirected to the vote login page
    
  Scenario: Incorrect login
    When I try to vote with "B123"
    Then I am not allowed to vote
  
  Scenario: Correct login
    When I try to vote with "A123"
    Then I am allowed to vote
    Given I vote
    Then "A123" has voted once
