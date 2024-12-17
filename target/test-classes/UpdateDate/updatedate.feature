Feature: update date csv

  Background:
   * def CsvUtils = Java.type('utils.CsvUtils')

  @Csv
  Scenario Outline: Update the due date for a specific row in the CSV file
    Given def csvUpdate = "D:\\PruebaTecnica\\src\\test\\resources\\UpdateData\\recaudo.csv"
    * def row = <row>
    * def newDueDate = <newDueDate>
    * def resultUpdate = CsvUtils.csvUpdate(csvUpdate, row, newDueDate)
    When  print resultUpdate
    Then match resultUpdate == newDueDate

    Examples:
      | row | newDueDate   |
      | 3   | '2024-12-20' |

    Scenario: probando
      * def testear = "hola mundo"
      * print testear




