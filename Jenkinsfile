pipeline {
  agent { label 'windows-agent' }

  environment {
    // Credenciales Flyway y BBDD
    FLYWAY_LICENSE_KEY        = credentials('flyway-license-key')
    FLYWAY_SQLSERVER_USER     = credentials('jenkins-sqlserver-user')
    FLYWAY_SQLSERVER_PASSWORD = credentials('jenkins-sqlserver-pass')
    //FLYWAY_ORACLE_USER        = credentials('jenkins-oracle-user')
    //FLYWAY_ORACLE_PASSWORD    = credentials('jenkins-oracle-pass')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Flyway Validate') {
      steps {
        bat """        
        flyway -environment=production -configFiles=Server/SQLServer/Demo-TEXT/MyDatabase/flyway.toml validate
        """
      }
    }

    stage('Flyway Migrate') {
      steps {
        bat """
        cd Server/SQLServer/Demo-TEXT/MyDatabase
        flyway -environment=production -configFiles=./flyway.toml migrate
        """
      }
    }

    stage('Flyway Info') {
      steps {
        bat """
        cd Server/SQLServer/Demo-TEXT/MyDatabase
        flyway -environment=production -configFiles=./flyway.toml info > ./info-sqlserver_dev.txt
        """
        archiveArtifacts artifacts: 'Server/SQLServer/Demo-TEXT/MyDatabase/info-*.txt', onlyIfSuccessful: true
      }
    }

    stage('Flyway validar snapshots') {
      when { branch 'DEV' }
      steps {
        bat """
        cd Server/SQLServer/Demo-TEXT/MyDatabase
        if not exist snapshots/dev-baseline.sql (
            flyway snapshot -environment=development -configFiles=./flyway.toml -snapshot.filename=snapshots/dev-baseline.sql
        ) else (
            echo Snapshot ya existe. No se necesita generar.
        )
        """
      }
    }

    stage('Flyway Drift Report') {
      when { branch 'DEV' }
      steps {
        bat """
        cd Server/SQLServer/Demo-TEXT/MyDatabase
        flyway check -drift -environment=production -check.deployedSnapshot=snapshots/dev-baseline.sql -reportFilename=reports/drift-report.html
        """
             }
    }

    stage('Enviar email Drift Report') {
      when { branch 'DEV' }
      steps {
        script {
          def reportDir = 'Server/SQLServer/Demo-TEXT/MyDatabase/reports'
          def htmlFiles = bat(script: "dir /b \"${reportDir}\\*.html\"", returnStdout: true).trim()

          if (htmlFiles) {
            echo "Se encontraron archivos HTML. Enviando correo..."

            emailext (
              subject: "Flyway Drift Report - ${env.BRANCH_NAME}",
              body: """<p>Se adjunta el reporte de Drift generado por Flyway en el entorno <b>${env.BRANCH_NAME}</b>.</p>""",
              mimeType: 'text/html',
              attachLog: false,
              attachmentsPattern: "${reportDir}/*.html",
              to: 'carlos.adames@babelgroup.com' // Cambia esto por el destinatario real
            )

            // Borrar los archivos HTML después de enviar
            bat "del /q \"${reportDir}\\*.html\""
          } else {
            echo "No se encontraron archivos HTML. No se enviará ningún correo."
          }
        }
      }
    }

    stage('Approval Gate') {
      when { branch 'qa|prod' }
      steps {
        input message: "Approve deployment to ${env.BRANCH_NAME}?", ok: 'Deploy'
      }
    }

    stage('Post-Migrate Validation') {
      when { branch 'qa|prod' }
      steps {
        bat """
        cd Server/SQLServer/Demo-TEXT/MyDatabase
        flyway -environment=production -configFiles=./flyway.toml validate
        """
      }
    }
  }

  post {
    always {
      cleanWs()
    }
  }
}
