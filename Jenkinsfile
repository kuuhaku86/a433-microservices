pipeline {
    agent any // Default agent for stages that don't specify their own
    environment {
        GITHUB_PAT = credentials('github-token')
        PATH = "${env.WORKSPACE}/.bin:${env.PATH}"
    }
    stages {
        stage('setup-tools') {
            steps {
                sh '''
                mkdir -p .bin
                if [ ! -f .bin/hadolint ]; then
                    curl -sSfL https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o .bin/hadolint
                    chmod +x .bin/hadolint
                fi
                '''
            }
        }
        stage('lint-dockerfile') {
            steps {
                sh 'hadolint Dockerfile'
            }
        }
        stage('build-app-karsajobs-ui') {
            agent {
                // This agent specifically for Docker operations.
                // It runs inside a Docker container with the host's Docker socket mounted.
                // This allows the container to use the host's Docker daemon.
                docker {
                    image 'docker:latest' // Contains Docker client
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'bash build_push_image_karsajobs_ui.sh'
            }
        }
    }
}
