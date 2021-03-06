Feature: verifying links to the local filesystem

  As a documentation writer
  I want to know whether links to local files in my code base work
  So that I can point my readers to example code that is part of my documentation.

  - links pointing to non-existing local files or directories
    cause the test to fail


  Scenario: link to existing local file
    Given my source code contains the file "1.md" with content:
      """
      [link to existing local file](1.md)
      """
    When running text-run
    Then it signals:
      | FILENAME | 1.md                    |
      | LINE     | 1                       |
      | MESSAGE  | link to local file 1.md |



  Scenario: link to existing local directory
    Given my source code contains the file "1.md" with content:
      """
      [link to local directory](.)
      """
    When running text-run
    Then it signals:
      | FILENAME | 1.md                      |
      | LINE     | 1                         |
      | MESSAGE  | link to local directory . |


  Scenario: link to non-existing local file
    Given my source code contains the file "1.md" with content:
      """
      [link to non-existing local file](zonk.md)
      """
    When trying to run text-run
    Then the test fails with:
      | FILENAME      | 1.md                                    |
      | LINE          | 1                                       |
      | ERROR MESSAGE | link to non-existing local file zonk.md |
      | EXIT CODE     | 1                                       |


  Scenario: link to existing local file in higher directory
    Given my source code contains the file "readme.md" with content:
      """
      Hello
      """
    And my source code contains the file "documentation/1.md" with content:
      """
      [link to existing local file](../readme.md)
      """
    When running text-run
    Then it signals:
      | FILENAME | documentation/1.md           |
      | LINE     | 1                            |
      | MESSAGE  | link to local file readme.md |
