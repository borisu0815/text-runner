Feature: running multiple console commands

  As a tutorial writer
  I want my users to be able to run multiple console commands at once
  So that they can follow more complex tutorial steps efficiently.

  - all commands provided are run in a Bash shell, concatenated via " && "


  Scenario: running multiple console commands
    Given I am in a directory containing a file "running-multiple-commands.md" with the content:
      """
      <a class="tutorialRunner_consoleCommand">
      ```
      ls -1
      ls -a
      ```
      </a>
      """
    When running "tut-run"
    Then it prints:
      """
      running-multiple-commands.md:1 -- running console command: ls -1 && ls -a
      running-multiple-commands.md
      .
      ..
      running-multiple-commands.md
      """
    And the test passes