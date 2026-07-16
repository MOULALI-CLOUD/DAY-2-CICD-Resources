pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Choose Terraform action'
        )
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/MOULALI-CLOUD/DAY-2-CICD-Resources.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Terraform Destroy') {
            when {
                expression {
                    params.ACTION == 'destroy'
                }
            }
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }

    post {
        success {
            echo "Terraform ${params.ACTION} completed successfully"
        }
        failure {
            echo "Terraform ${params.ACTION} failed"
        }
    }
}
