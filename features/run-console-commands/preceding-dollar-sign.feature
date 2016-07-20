Feature: marking console commands with preceding dollar signs

  As a tutorial writer
  I want to visualize console commands in my tutorial via preceding dollar signs
  So that my readers can distinguish them from other code blocks.

  - the commands can be preceded by a dollar sign,
    which is stripped before running them


  Scenario: running console commands with dollar signs
    Given I am in a directory containing a file "running-with-dollar-sign.md" with the content:
      """
      <a class="tutorialRunner_ConsoleCommand">
      ```
      $ ls -1
      $ ls -a
      ```
      </a>
      """
    When running "tut-run"
    Then it prints:
      """
      running-with-dollar-sign.md:1 -- running console commands: ls -1 && ls -a
      running-with-dollar-sign.md
      .
      ..
      running-with-dollar-sign.md
      """
    And the test passes