Feature: In order to have access to my profile
  I need to have a way to manage my account

  Scenario: Log in works for registered user
    Given I have one user "john@doe.com" with password "very_secret" and login "johndoe"
    And I go to login
    And I fill in "user_email" with "john@doe.com"
    And I fill in "user_password" with "very_secret"
    And I press "Sign in"
    Then I should see "Welcome john@doe.com"
