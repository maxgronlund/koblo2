Feature: In order to see what's going on with interesting people on Koblo
  I want to be able to follow other persons
  And get notified when they're doing something

  Background:
    Given a user called "Joe"
    And a user called "Nephew"

  Scenario: Looking at your own profile
    Given I am logged in as "Joe"
    And I am looking at the profile page for "Joe"
    Then I should see "This is you"

  Scenario: Not following each other
    Given I am logged in as "Joe"
    And I am looking at the profile page for "Nephew"
    Then I should see "Follow Nephew"

  Scenario: Fan following a band - Fan view
    Given I am logged in as "Joe"
    And "Joe" is following "Nephew"
    And I am looking at the profile page for "Nephew"
    Then I should see "Following"
  
  Scenario: Fan following a band - Band view
    Given I am logged in as "Nephew"
    And "Joe" is following "Nephew"
    And I am looking at the profile page for "Joe"
    Then I should see "Follows You"

  Scenario: Connected
    Given I am logged in as "Nephew"
    And "Joe" is following "Nephew"
    And "Nephew" is following "Joe"
    And I am looking at the profile page for "Joe"
    Then I should see "Connected"

  Scenario: Creating a connection
    Given I am logged in as "Joe"
    And I am looking at the profile page for "Nephew"
    And I follow "Follow Nephew"
    Then I should see "Following"

  Scenario: Removing a connection
    Given I am logged in as "Joe"
    And "Joe" is following "Nephew"
    And I am looking at the profile page for "Nephew"
    And I follow "Unfollow Nephew"
    Then I should see "Follow Nephew"

  Scenario: Activity from a connection
    Given "Joe" is following "Nephew"
    And "Nephew" just added a song called "DTAP"
    Given I am logged in as "Joe"
    Then I should see "Nephew added a new song called DTAP"

