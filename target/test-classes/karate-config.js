function fn() {
  var config = {};

  // Configuración global de Karate
  config.baseUrl = 'https://api.tu-servicio.com'; // Reemplazar con la URL base de tu API
  config.bucketName = 'test-automation-qa'; // Nombre del bucket S3
  config.currentFilePath = '/path/to/current/files';
  config.newPathNewFile = '/path/to/renamed/files'

  // Configuración de headers o autenticación, si es necesario
  config.headers = {
    Authorization: 'Bearer <token>',
    'Content-Type': 'application/json'
  };

  // Otros valores o configuraciones necesarias
  config.retryInterval = 3000; // Retraso entre reintentos en milisegundos

  karate.log("Cargando configuraciones");

  return config;
}


}