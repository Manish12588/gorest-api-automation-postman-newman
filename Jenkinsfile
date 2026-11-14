pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile'
            args '--entrypoint='      // your image has ENTRYPOINT ["newman"], Jenkins needs a free entrypoint
        }
    }

    options { buildDiscarder(logRotator(numToKeepStr: '5')) }

    environment {
        GOREST_TOKEN = credentials('gorest-token')
    }

    stages {
        stage('Run Workflow Collection') {
            steps {
                sh '''
                    ENV_FILE=environments/GoRestEnv.example.json \
                    TOKEN_ID="$GOREST_TOKEN" \
                    scripts/run-newman.sh collections/GoRestAPI-Workflow-v3.json workflow
                '''
            }
        }
    }

    post {
        always {
            publishHTML(target: [
                reportDir: 'reports', reportFiles: 'workflow-latest.html',
                reportName: 'NewmanReport', keepAll: true,
                alwaysLinkToLastBuild: true, allowMissing: true
            ])
        }
    }
}