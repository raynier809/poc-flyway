pipeline {
    agent { label 'windows-agent' }

    stages {
        stage('Crear archivo en Windows') {
            steps {
                bat '''
                cd C:\\Conexio
                echo Conexion exitosa, ahora? > conn.txt
                '''
            }
        }
    }
}
