@ballots @ballots-engine
Feature: Create ballot

  Background:
    Given I am a logged in refinery user
    And I have no ballots, offices, or candidates
  
  Scenario: Create a Ballot
    Then I should be able to add a ballot
    | start_date         | end_date           | title     |
    | September  9, 2011 | September 12, 2011 | president |

  Scenario: Create offices on a ballot
    Given a Ballot
    Then I should be able to add offices
    |title|number_of_positions|
    |Vice President|1|
    |Board Member|4|
  
  Scenario: Add candidates to offices
    Given a ballot with an office
    Then I should be able to add candidates
    |name|
    |John Smith|
    |Smiley Bob|
    |Jackson Andrews|

  Scenario: Create all three in one swoop
    Given I can create a ballot that accepts nested attributes for offices and candidates
      
