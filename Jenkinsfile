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
        flyway -environment=production -configFiles=${env.BRANCH_NAME}\\Server\\SQLServer\\Demo-TEXT\\MyDatabase\\flyway.toml validate
        """
      }
    }

    stage('Flyway Migrate') {
      steps {
        bat """
        flyway -environment=production -configFiles=${env.BRANCH_NAME}\\Server\\SQLServer\\Demo-TEXT\\MyDatabase\\flyway.toml migrate
        """
      }
    }

    stage('Flyway Info') {
      steps {
        bat """
        cd C:\\Demo\\Server\\SQLServer\\Demo-TEXT\\MyDatabase
        flyway -environment=production info > info-sqlserver.txt
        """
        archiveArtifacts artifacts: 'info-*.txt', fingerprint: true
      }
    }

    stage('Flyway Drift Report') {
      when { branch 'dev|qa' }
      steps {
        bat """
        cd C:\\Demo\\Server\\SQLServer\\Demo-TEXT\\MyDatabase
        flyway -environment=production drift --outputHtml=drift-sqlserver.html
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
        cd C:\\Demo\\Server\\SQLServer\\Demo-TEXT\\MyDatabase
        flyway -environment=production validate
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
