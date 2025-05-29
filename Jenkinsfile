pipeline {
    agent { label 'windows' }

    stages {
        stage('Crear archivo en Windows') {
            steps {
                bat '''
                cd C:\\Conexio
                echo Archivo creado por Jenkins > conn.txt
                '''
            }
        }
    }
}
