Feature: update date csv

  Background:
    * def CsvUtils = Java.type('utils.CsvUtils')

  @Csv
  Scenario Outline: Update the due date for a specific row in the CSV file
    Given def csvUpdate = "D:\\PruebaTecnica\\src\\test\\resources\\UpdateData\\recaudo.csv"
    * def row = <row>
    * def newDueDate = "<newDueDate>"
    * def result = CsvUtils.csvUpdate(csvUpdate, row, newDueDate)
    * def datanewCsv = CsvUtils.assertUpdate(csvUpdate, row)
    * print datanewCsv

    Examples:
      | row | newDueDate   |
      | 2   | '2024-11-20' |




