Feature: verifying global commands provided by NPM modules

  When developing an NPM module that is used as a global command
  I want to be able to specify the name of available global commands
  So that my users know how to call my library.

  - surround the installation instructions via the "verifyNpmGlobalCommand" action


  Background:
    Given my source code contains the file "package.json" with content:
      """
      {
        "bin": {
          "foo": "bin/foo"
        }
      }
      """


  Scenario: correct command name with triple-fenced code block
    Given my source code contains the file "1.md" with content:
      """
      To run this app, call:

      <a class="tr_verifyNpmGlobalCommand">
      ```
      $ foo
      ```
      </a>
      """
    When running text-run
    Then it signals:
      | FILENAME | 1.md                          |
      | LINE     | 3-7                           |
      | MESSAGE  | provides a global foo command |


  Scenario: correct command name with single-fenced code block
    Given my source code contains the file "1.md" with content:
      """
      To run this app, call <a class="tr_verifyNpmGlobalCommand">`foo`</a> on the command line
      """
    When running text-run
    Then it signals:
      | FILENAME | 1.md                          |
      | LINE     | 1                             |
      | MESSAGE  | provides a global foo command |


  Scenario: mismatching command name
    Given my source code contains the file "1.md" with content:
      """
      To run this app, call:

      <a class="tr_verifyNpmGlobalCommand">
      ```
      $ zonk
      ```
      </a>
      """
    When trying to run text-run
    Then the test fails with:
      | FILENAME      | 1.md                                        |
      | LINE          | 3-7                                         |
      | ERROR MESSAGE | package.json does not export a zonk command |
      | EXIT CODE     | 1                                           |


  Scenario: missing command name
    Given my source code contains the file "1.md" with content:
      """
      To run this app, call:

      <a class="tr_verifyNpmGlobalCommand">
      </a>
      """
    When trying to run text-run
    Then the test fails with:
      | FILENAME      | 1.md                              |
      | LINE          | 3                                 |
      | MESSAGE       | verifying exported global command |
      | ERROR MESSAGE | missing code block                |
      | EXIT CODE     | 1                                 |
