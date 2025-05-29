pipeline {
    agent { label 'windows' }

    stages {
        stage('Crear archivo en Windows') {
            steps {
                bat '''
                cd C:\\Conexio
                echo Archivos creado por Jenkins > conn.txt
                '''
            }
        }
    }
}
