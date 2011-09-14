@voting
Feature: Voting

  Scenario: Casting a vote
    Given a ballot with offices and candidates
    When I I view the ballot
    And I select "Bradford" for "President"
    And I select "Jim" for "Vice President"
    And I select "Joe", "Bob", and "Pete" for "Board of Directors"
    And I cast my vote
    Then "Bradford" has 1 vote for "President"
    And "Gary" has 0 votes for "President"
    And "Jim" has 1 vote for "Vice President"
    And "Cara" has 0 votes for "Vice President" 
    And "Joe" has 1 vote for "Board of Directors"
    And "Bob" has 1 vote for "Board of Directors"
    And "Pete" has 1 vote for "Board of Directors"
    And "Uma" has 0 votes for "Board of Directors"

  Scenario: Over voting
    Given a ballot with offices and candidates
    When I I view the ballot
    And I select "Bradford" for "President"
    And I select "Gary" for "President"
    And I cast my vote
    Then my vote should not be valid
    And "Gary" has 0 votes for "President"
    And "Bradford" has 0 votes for "President"
  
  Scenario: Under voting
    Given a ballot with offices and candidates
    When I I view the ballot
    And I select "Jim" for "Vice President"
    And I cast my vote
    Then "Jim" should have 1 vote for "Vice President"
    And "Gary" should have 0 votes for "President"
    And "Bradford" should have 0 votes for "President"
