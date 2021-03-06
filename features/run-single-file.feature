Feature: running a single MarkDown file

  As a documentation writer
  I want to be able to test a single MarkDown file
  So that I can check my current changes quickly without having to run the entire test suite.

  - run "text-run run [<file path>]" or "text-run [<file path>]" to test only the given file


  Background:
    Given my source code contains the file "1.md" with content:
      """
      <a class="tr_verifyWorkspaceContainsDirectory">
      `.`
      </a>
      """
    Given my source code contains the file "2.md" with content:
      """
      <a class="tr_verifyWorkspaceContainsDirectory">
      `.`
      </a>
      """


  Scenario: testing a single file via "text-run run"
    When running text-run with the argument "run 2.md"
    Then it runs only the tests in "2.md"


  Scenario: testing a single file via "text-run"
    When running text-run with the argument "2.md"
    Then it runs only the tests in "2.md"


  Scenario: testing a non-existing file
    When trying to run text-run with the argument "zonk.md"
    Then the test fails with:
      | ERROR MESSAGE | unknown command: zonk.md |
      | EXIT CODE     | 1                        |
