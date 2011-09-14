@ballots
Feature: Show the ballot

Scenario:  Show to a user
  Given a ballot with multiple offices and candidates
  When I view the ballot
  Then I should see all the offices and candidates
