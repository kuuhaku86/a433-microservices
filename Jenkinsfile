pipeline {
    agent any // No default agent, each stage defines its own environment
    stages {
        // Removed 'setup-tools' stage as tools will be provided by Docker agents
        stage('lint-dockerfile') {
            agent {
                docker {
                    image 'hadolint/hadolint:latest-debian' // Use a dedicated Hadolint image
                    // No Docker socket mount needed for linting
                }
            }
            steps {
                sh 'hadolint Dockerfile'
            }
        }
        stage('build-app-karsajobs-ui') {
            agent {
                docker {
                    image 'docker:latest' // Provides an up-to-date Docker client
                    // Mount the host's Docker socket to allow the client inside this container
                    // to communicate with the Docker daemon running on the Minikube host.
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                script {
                    withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_PAT')]) {
                        sh 'bash build_push_image_karsajobs_ui.sh'
                    }
                }
            }
        }
    }
    post {
        always {
            // Clean up the workspace after each build to ensure a clean state
            deleteDir()
        }
    }
}
