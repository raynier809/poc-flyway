pipeline {
  agent any

  environment {
    // Credenciales Flyway y BBDD
    FLYWAY_LICENSE_KEY        = credentials('flyway-license-key')
    FLYWAY_SQLSERVER_USER     = credentials('jenkins-sqlserver-user')
    FLYWAY_SQLSERVER_PASSWORD = credentials('jenkins-sqlserver-pass')
    FLYWAY_ORACLE_USER        = credentials('jenkins-oracle-user')
    FLYWAY_ORACLE_PASSWORD    = credentials('jenkins-oracle-pass')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Flyway Validate') {
      steps {
        script {
          sh "flyway -c ${env.BRANCH_NAME}/Server/SQLServer/Demo-TEXT/MyDatabase/flyway.toml validate"
          sh "flyway -c ${env.BRANCH_NAME}/Server/Oracle/MyOracleContainer/ORCL/flyway.toml validate"
        }
      }
    }

    stage('Flyway Migrate') {
      when { branch 'QA' }
      steps {
        script {
          sh "flyway -c ${env.BRANCH_NAME}/Server/SQLServer/Demo-TEXT/MyDatabase/flyway.toml migrate"
          sh "flyway -c ${env.BRANCH_NAME}/Server/Oracle/MyOracleContainer/ORCL/flyway.toml migrate"
        }
      }
    }

    stage('Flyway Info') {
      steps {
        script {
          sh "flyway -c ${env.BRANCH_NAME}/Server/SQLServer/Demo-TEXT/MyDatabase/flyway.toml info > info-sqlserver.txt"
          sh "flyway -c ${env.BRANCH_NAME}/Server/Oracle/MyOracleContainer/ORCL/flyway.toml info > info-oracle.txt"
          archiveArtifacts artifacts: 'info-*.txt', fingerprint: true
        }
      }
    }

    stage('Flyway Drift Report') {
      when { branch 'DEV|QA' }
      steps {
        script {
          sh "flyway -c ${env.BRANCH_NAME}/Server/SQLServer/Demo-TEXT/MyDatabase/flyway.toml drift --outputHtml=drift-sqlserver.html"
          sh "flyway -c ${env.BRANCH_NAME}/Server/Oracle/MyOracleContainer/ORCL/flyway.toml drift --outputHtml=drift-oracle.html"
        }
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
      when { branch 'QA|PRD' }
      steps {
        input message: "Approve deployment to ${env.BRANCH_NAME}?", ok: 'Deploy'
      }
    }

    stage('Post-Migrate Validation') {
      when { branch 'QA|PRD' }
      steps {
        script {
          sh "flyway -c ${env.BRANCH_NAME}/Server/SQLServer/Demo-TEXT/MyDatabase/flyway.toml validate"
          sh "flyway -c ${env.BRANCH_NAME}/Server/Oracle/MyOracleContainer/ORCL/flyway.toml validate"
        }
      }
    }
  }

  post {
    always {
      cleanWs()
    }
    failure {
      mail to: 'raynieradames@gmail.com',
           subject: "Build failed in ${env.JOB_NAME} #${env.BUILD_NUMBER}",
           body: "Revisar consola: ${env.BUILD_URL}"
    }
  }
}
