pipeline {
    agent any

    options {
        // Keep the history of the last 5 builds only
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    environment {
        // Token comes from the Jenkins credential (Secret text, ID: gorest-token)
        GOREST_TOKEN = credentials('gorest-token')
    }

    stages {

        // Jenkins checks out the repo automatically ("Pipeline script from SCM"),

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t gorest-newman .'
            }
        }

        stage('Run API Test Cases') {
            steps {
                // Mounts the workspace into the container and runs the script from the repo.
                // Reports are written to reports/ in the workspace.
                sh '''
                    docker run --rm \
                      -v "$(pwd)":/app \
                      -e ENV_FILE=environments/GoRestEnv.example.json \
                      -e TOKEN_ID="$GOREST_TOKEN" \
                      --entrypoint scripts/run-newman.sh \
                      gorest-newman \
                      collections/GoRestAPI-Workflow-v3.json workflow
                '''
            }
        }
    }

    post {
        always {
            // Runs even when the tests fail, so the report is always published
            publishHTML(target: [
                allowMissing: false,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'reports',
                reportFiles: 'workflow-latest.html',
                reportName: 'NewmanReport'
            ])
        }
    }
}