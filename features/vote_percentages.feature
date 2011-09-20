@vote_percentages
Feature: Vote percentages

  Scenario: some people don't vote
    Given a 2 person election, with 1 position available
      |Jim|
      |Carl|
    Given 4 people vote for Jim
    Given 3 people vote for Carl
    Given 3 people vote for neither
    Then election Results should be
      | candidate | votes | percentage |
      | Jim       | 4     | 40%        |
      | Carl      | 3     | 30%        |


  Scenario: some people vote for both candidates, some for only one
    Given a 2 person election, with 2 positions available
      |Jim|
      |Carl|
    Given Sally votes for Jim, Carl
    Given Bill votes for Jim
    Then election Results should be
      | candidate | votes | percentage |
      | Jim       | 2     | 100%       |
      | Carl      | 1     | 50%        |
    And total votes should be 3
    And total people voted should be 2


  Scenario: a complex example
    Given a 4 person election, with 2 positions available
      |Jim|
      |Carl|
      |Gene|
      |Bradford|
    Given Sally votes for Jim, Carl
    Given Bill votes for Jim
    Given Doug votes for Gene, Jim
    Then election Results should be
      | candidate | votes | percentage |
      | Jim       | 3     | 100%       |
      | Carl      | 1     | 33%        |
      | Gene      | 1     | 33%        |
      | Bradford  | 0     | 0%         |
    And total votes should be 5
    And total people voted should be 3
