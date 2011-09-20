@ballots
Feature: Show the ballot

Scenario:  Show to admin
  Given a ballot with multiple offices and candidates
  And I am a logged in refinery user
  When I view the admin ballot
  Then I should see all the offices and candidates
