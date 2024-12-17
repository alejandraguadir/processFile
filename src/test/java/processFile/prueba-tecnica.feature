Feature: procesar archivos de recaudo
  Background:
    * configure retry = {count: 3, interval: 3000}
    # La clase S3Util se encuentra en un gestor de librerías externo al proyecto
    # Imaginemos que esta clase contiene la configuración y conexión de un cliente AWS, además los métodos para subir archivos a buckets S3
    # También contiene un método para verificar si un archivo se encuentra dentro de un folder
   # * def S3Manager = Java.type('co.cobre.lib.qa.aws.S3Util')
    #* def S3ManagerInstance = new S3Manager()
  #  * def SQSManager = karate.callSingle('../acceptance/test/instances-sqs.js')
  #  * def waitTime = function(seconds) { java.lang.Thread.sleep(seconds * 1000) }
    # La clase FileUtils se encuentra en un gestor de librerías externo al proyecto
    # Imaginemos que esta clase contiene métodos para tomar un archivo, renombrarlo y copiarlo en otra ruta
    #* def FileUtils = Java.type('co.cobre.lib.qa.util.FileUtils')

    # Variables globales
    * def bucketName = 'test-automation-qa'
    * def folderRecaudoFiles = 'files-to-cash-in'
    * def fileExtension = ".csv"
    * def noveltyUuid = java.util.UUID.randomUUID().toString()
    * def fullFileName = noveltyUuid + fileExtension
    * def urlBase = 'https://test-container-qa.prueba.co/v1/entity/novelties/'


  @regression
  Scenario Outline: Dado que se carga un archivo de recaudo con datos correctamente con usuarios que recibirán un link de pago, al procesarse el archivo se persisten en BD los recaudo creados exitosamente
    #Generación de un UUID único para cada prueba
    * karate.log('El uuid de la novedad es: ', noveltyUuid)

    # Renombrar archivo
    * def renameFile = FileUtils.renameFile(currentFilePath, currentFileName, newPathNewFile, noveltyUuid, fileExtension)
    * match renameFile == true
    * karate.log('Renombrado correctamente: ', renameFile)

    #  Subir archivo a S3
    * S3ManagerInstance.uploadFileToBucket(bucketName, folderRecaudoFiles, fullFileName, newPathNewFile)
    * def fileExist = S3ManagerInstance.doesFileExist(bucketName, folderRecaudoFiles, fullFileName)
    * match fileExist == true
    * karate.log('Archivo subido correctamente a S3: ', fileExist)

    # Enviar mensaje a SQS
    * def variableMapToReplaceInQueueMessageBody =
    """
    {
    "fileName": '#(fullFileName)',
    "workplacebankCode": '<clientCode>',
    "bucketName": '#(bucketName)'
    }
    """
    * SQSManager.sendMessageToQueue('<jsonFileSqsEvents>', 'testing-recaudo-qa.fifo', variableMapToReplaceInQueueMessageBody, '<pathJsonFileSqsEvents>')


    # --------------------------------------------------------------- #
    # API REST para obtener información de las novedades
    Given url urlBase + noveltyUuid + ''
    And header X-WorkplaceBankCode = '<clientCode>'
    And retry until responseStatus == 200 && response.cashInNovelty.status == status && response.cashInNoveltyDetailsCounters.total == total
    When method get
    Then status 200
    * def totalAmount = response.cashInNovelty.totalAmount
    * def status = response.cashInNovelty.status
    * def totalNovelties = response.cashInNoveltyDetailsCounters.total
    * def validationError = response.cashInNoveltyDetailsCounters.validationError
    * karate.log('Datos de la novedad: ', totalAmount, status, totalNovelties, validationError)
    * def created = response.cashInNoveltyDetailsCounters.created#    * match totalAmount == '<>'
    #Revisar opciones de mejora
    * match getNovelty.status == '<noveltyStatus>'
    * match getNovelty.totalNovelties == '<registerTotal>'
    * match getNovelty.validationError == <validationErrorNumber>
    * match getNovelty.created == <createdNumber>


    # --------------------------------------------------------------- #
    # Uso de API REST para obtener información de las novelty-details
    * def dataWithExpectedInformation = karate.read("classpath:acceptance/test/" + '<jsonDataWithExpectedInformation>')
    * def pageInt = parseInt('<page>')
    * def sizeInt = parseInt('<size>')
    Given url  urlBase + noveltyUuid+''+'/novelty-details'
    And header X-WorkplaceBankCode = '<clientCode>'
    And params {page: '0', size: '100'}
    And retry until responseStatus == 200 && response.content != []
    When method get
    Then status 200
    * def content = response.content
    * karate.log('Detalles de la novedad: ', content)
    * match getNoveltyDetails.content contains deep dataWithExpectedInformation

    Examples:
      | clientCode | pathJsonFileSqsEvents          | jsonFileSqsEvents | currentFilePath                | currentFileName                   | newPathNewFile                     | pathJsonDataWithExpectedInformation | jsonDataWithExpectedInformation      | noveltyStatus | registerTotal | validationErrorNumber | createdNumber | page | size |
      | TEST01     | src/test/java/acceptance/test/ | queueEvent.json   | src/test/java/acceptance/test/ | recaudoTemplateDatosCorrectos.csv | src/test/resources/testFilesToUse/ | src/test/java/acceptance/test/      | respuestaEsperadaDatosCorrectos.json | VALIDATED     | 3             | '0'                   | '3'           | 1    | 3    |

  @regression
  Scenario Outline: Dado que se carga un archivo de recaudo con datos que contienen caracteres especiales, al procesarse el archivo se verificará la información y se persistirán en BD con el detalle del error
    # --------------------------------------------------------------- #
    #Generación de un UUID único para cada prueba
    * karate.log('El uuid de la novedad es: ', noveltyUuid)

    # Renombrar archivo
    * def renameFile = FileUtils.renameFile(currentFilePath, currentFileName, newPathNewFile, noveltyUuid, fileExtension)
    * match renameFile == true
    * karate.log('Renombrado correctamente: ', renameFile)

       #  Subir archivo a S3
    * S3ManagerInstance.uploadFileToBucket(bucketName, folderRecaudoFiles, fullFileName, newPathNewFile)
    * def fileExist = S3ManagerInstance.doesFileExist(bucketName, folderRecaudoFiles, fullFileName)
    * match fileExist == true
    * karate.log('Archivo subido correctamente a S3: ', fileExist)


    # Enviar mensaje a SQS
    * def variableMapToReplaceInQueueMessageBody =
     """
    {
    "fileName": '#(fullFileName)',
    "workplacebankCode": '<clientCode>',
    "bucketName": '#(bucketName)'
    }
    """
    * SQSManager.sendMessageToQueue('<jsonFileSqsEvents>', 'testing-recaudo-qa.fifo', variableMapToReplaceInQueueMessageBody, '<pathJsonFileSqsEvents>')


    # --------------------------------------------------------------- #
    # Uso de API REST para obtener información de las novedades
    Given url urlBase + noveltyUuid+''
    And header X-WorkplaceBankCode = '<clientCode>'
    And retry until responseStatus == 200 && response.cashInNovelty.status == status && response.cashInNoveltyDetailsCounters.total == total
    When method get
    Then status 200
    * def totalAmount = response.cashInNovelty.totalAmount
    * def status = response.cashInNovelty.status
    * def totalNovelties = response.cashInNoveltyDetailsCounters.total
    * def validationError = response.cashInNoveltyDetailsCounters.validationError
    * def created = response.cashInNoveltyDetailsCounters.created#    * match totalAmount == '<>'
    * match getNovelty.status == '<noveltyStatus>'
    * match getNovelty.totalNovelties == '<registerTotal>'
    * match getNovelty.validationError == <validationErrorNumber>
    * match getNovelty.created == <createdNumber>


    # --------------------------------------------------------------- #
    # Uso de API REST para obtener información de las novelty-details
    * def dataWithExpectedInformation = karate.read("classpath:acceptance/test/" + '<jsonDataWithExpectedInformation>')
    * def pageInt = parseInt('<page>')
    * def sizeInt = parseInt('<size>')
    Given url urlBase + noveltyUuid+''+'/novelty-details'
    And header X-WorkplaceBankCode = '<clientCode>'
    And params {page: '0', size: '100'}
    And retry until responseStatus == 200 && response.content != []
    When method get
    Then status 200
    * def content = response.content
    * match getNoveltyDetails.content contains deep dataWithExpectedInformation

    Examples:
      | clientCode | pathJsonFileSqsEvents          | jsonFileSqsEvents | currentFilePath                | currentFileName                         | newPathNewFile                     | pathJsonDataWithExpectedInformation | jsonDataWithExpectedInformation            | noveltyStatus | registerTotal | validationErrorNumber | createdNumber | page | size |
      | TEST01     | src/test/java/acceptance/test/ | queueEvent.json   | src/test/java/acceptance/test/ | recaudoTemplateCaracteresEspeciales.csv | src/test/resources/testFilesToUse/ | src/test/java/acceptance/test/      | respuestaEsperadaCaracteresEspeciales.json | VALIDATED     | 2             | '2'                   | '0'           | 1    | 2    |





