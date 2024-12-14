pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/lib/jvm/java-11-openjdk-amd64'
        MAVEN_HOME = '/opt/apache-maven-3.8.1'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/alejandraguadir/processFile.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    // Construcción con Maven
                    sh 'mvn clean install'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Ejecutar las pruebas con Karate DSL
                    sh 'mvn test -Dtest=karate'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finalizado.'
        }
        success {
            echo 'Construcción y pruebas exitosas.'
        }
        failure {
            echo 'Hubo un error en la construcción o las pruebas.'
        }
    }
}
