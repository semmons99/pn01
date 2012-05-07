Feature: Calculating Totals

  Scenario: with sample data
    Given a rates file data/SAMPLE_RATES.xml
    And a trans file data/SAMPLE_TRANS.csv
    When I calculate the total for DM1182 in USD
    Then I get $134.22

    Scenario: with actual data
      Given a rates file data/RATES.xml
      And a trans file data/TRANS.csv
      When I calculate the total for DM1182 in USD
      Then I get $59482.47
