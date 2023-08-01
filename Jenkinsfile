pipeline {
    agent { label 'PROJECT' }
    triggers { pollSCM ('* * * * *') }
    stages {
        stage('Clone_the_code') {
            steps {
                git branch: 'main',
                       url: 'https://github.com/maheshryali123/terraform_integration.git'
            }
        }
        stage('create_infra_in_aws') {
            steps {
                sh """
                terraform destroy -var-file="dev.tfvars" -auto-approve
                """
            }
        }
    }
}