@clionly
Feature: selecting formatter via the config file

  As a documentation writer
  I want to be able to configure which formatter TextRunner uses via the config file
  So that I can use my preferred output format all the time.

  - you can chose a formatter using the `formatter` key in `text-run.yml`


  Scenario Outline: formatter types in config file
    Given my workspace contains testable documentation
    And the configuration file:
      """
      format: <FORMATTER>
      """
    When running text-run
    Then it prints:
      """
      <OUTPUT>
      """

    Examples:
      | FORMATTER | OUTPUT      |
      | robust    | Hello world |
      | colored   | 1.md        |
      | iconic    | 1.md        |


  Scenario: selecting an unknown formatter
    Given my workspace contains testable documentation
    And the configuration file:
      """
      format: zonk
      """
    When trying to run text-run
    Then the call fails with the error:
      """
      Unknown formatter: 'zonk'

      Available formatters are colored, iconic, robust
      """
