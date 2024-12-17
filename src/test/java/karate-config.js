function fn() {
  var config = {};


  // Configuración global de Karate
  config.baseUrl = 'https://test-container-qa.prueba.co/v1/entity/novelties/';
  config.bucketName = 'test-automation-qa';
  config.folderRecaudoFiles = 'files-to-cash-in';
  config.fileExtension = '.csv';

  // Generación de un UUID único
  config.noveltyUuid = java.util.UUID.randomUUID().toString();
  config.fullFileName = config.noveltyUuid + config.fileExtension;

  // Rutas de archivos
  config.currentFilePath = '/path/to/current/files';
  config.newPathNewFile = '/path/to/renamed/files';

  // Headers globales
  config.headers = {
    Authorization: 'Bearer <token>',
    'Content-Type': 'application/json'
  };

  // Otros valores globales
  karate.configure('retry', { count: 3, interval: 3000 });

  //karate.log("Configuraciones globales cargadas:", config);

  return config;
}
