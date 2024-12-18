Feature: update date csv

  Background:
    * def CsvUtils = Java.type('utils.CsvUtils')
    * def csvUpdate = "recaudoTemplateCaracteresEspeciales.csv"

  @Csv
  Scenario Outline: Update the due date for a specific row in the CSV file
    Given  print csvUpdate
    * def row = <row>
    * def newDueDate = <newDueDate>
    * def resultUpdate = CsvUtils.csvUpdate(csvUpdate, row, newDueDate)
    When  print resultUpdate
    Then match resultUpdate == newDueDate

    Examples:
      | row | newDueDate   |
      | 1   | '2024-09-20' |







