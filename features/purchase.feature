Feature: In order to increase the revenue of koblo
  users should be able to buy several tracks in different currencies

  Scenario: User purchases a single song
    Given a song called "Hello" with a "multitrack" price of "2 EUR"
    When a user purchases "Hello" in "multitrack" format
    Then the total price of the purchase should be "2 EUR"

  Scenario: User purchases songs in different formats
    Given a song called "Hello" with a "multitrack" price of "2 EUR"
    And a song called "Words" with a "ringtone" price of "1.50 EUR"
    When a user purchases "Hello" in "multitrack" format
    And a user purchases "Words" in "ringtone" format
    Then the total price of the purchase should be "3.50 EUR"

  Scenario: User purchases songs in different currencies
    Given that the exchange rate of "DKK" to "EUR" is "7.5"
    Given that the exchange rate of "GBP" to "EUR" is "0.85"
    Given a song called "Hello" with a "multitrack" price of "15 DKK"
    And a song called "Words" with a "ringtone" price of "1 GBP"
    When a user purchases "Hello" in "multitrack" format
    When a user purchases "Words" in "ringtone" format
    Then the total price of the purchase should be "3.17 EUR"
