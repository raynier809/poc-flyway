pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo "Branch actual: ${env.BRANCH_NAME}"
                echo "Commit: ${env.GIT_COMMIT}"
            }
        }
        
        stage('Deploy to Dev') {
            when {
                branch 'dev'
            }
            steps {
                script {
                    echo "Ejecutando deployment en rama DEV"
                    
                    // Conectar al servidor Windows y ejecutar comando
                    withCredentials([usernamePassword(credentialsId: 'windows-server-creds', 
                                                    usernameVariable: 'WIN_USER', 
                                                    passwordVariable: 'WIN_PASS')]) {
                        
                        // Opción 1: Usando PowerShell remoto (recomendado)
                        bat """
                        powershell -Command "
                            \$securePassword = ConvertTo-SecureString '${WIN_PASS}' -AsPlainText -Force;
                            \$credential = New-Object System.Management.Automation.PSCredential('${WIN_USER}', \$securePassword);
                            Invoke-Command -ComputerName 155.248.227.97 -Credential \$credential -ScriptBlock {
                                New-Item -Path 'C:\\Demo\\Server\\SQLServer\\Demo-TEXT\\MyDatabase' -ItemType Directory -Force;
                                Set-Content -Path 'C:\\Demo\\Server\\SQLServer\\Demo-TEXT\\MyDatabase\\jenkins.txt' -Value 'Jenkins estuvo aqui...' -Encoding UTF8;
                                Write-Host 'Archivo jenkins.txt creado exitosamente';
                            }
                        "
                        """
                        
                        // Opción 2: Usando PsExec (alternativa)
                        // Necesitas tener PsExec en el servidor Jenkins
                        /*
                        bat """
                        psexec \\\\155.248.227.97 -u ${WIN_USER} -p ${WIN_PASS} -accepteula cmd /c "
                        if not exist C:\\Demo\\Server\\SQLServer\\Demo-TEXT\\MyDatabase mkdir C:\\Demo\\Server\\SQLServer\\Demo-TEXT\\MyDatabase &&
                        echo Jenkins estuvo aqui... > C:\\Demo\\Server\\SQLServer\\Demo-TEXT\\MyDatabase\\jenkins.txt
                        "
                        """Set-Item WSMan:\localhost\Client\TrustedHosts -Value "155.248.227.97" -Force

                        */
                    }
                }
            }
        }
        
        stage('Deploy to QA') {
            when {
                branch 'qa'
            }
            steps {
                echo "Ejecutando deployment en rama QA"
                // Aquí puedes agregar lógica específica para QA
            }
        }
        
        stage('Deploy to PRD') {
            when {
                branch 'prd'
            }
            steps {
                echo "Ejecutando deployment en rama PRD"
                // Aquí puedes agregar lógica específica para PRD
            }
        }
    }
    
    post {
        success {
            echo "Pipeline ejecutado exitosamente para la rama ${env.BRANCH_NAME}"
        }
        failure {
            echo "Pipeline falló para la rama ${env.BRANCH_NAME}"
        }
    }
}