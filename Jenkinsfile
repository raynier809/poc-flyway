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
        flyway -environment=production -configFiles=./flyway.toml info > info-sqlserver.txt
        """
        archiveArtifacts artifacts: 'info-*.txt', fingerprint: true
      }
    }

    stage('Flyway Drift Report') {
      when { branch 'dev|qa' }
      steps {
        bat """
        cd Server/SQLServer/Demo-TEXT/MyDatabase
        flyway -environment=production -configFiles=./flyway.toml drift --outputHtml=drift-sqlserver.html
        """
        publishHTML([
          allowMissing: false,
          alwaysLinkToLastBuild: true,
          keepAll: true,
          reportDir: '.',
          reportFiles: 'drift-*.html',
          reportName: "Drift Report (${env.BRANCH_NAME})"
        ])
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
