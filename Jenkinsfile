pipeline {
    agent any
    environment {
        PATH = "${env.WORKSPACE}/.bin/go/bin:${env.WORKSPACE}/.bin:${env.PATH}"
    }
    stages {
        stage ('setup-tools') {
            steps {
                sh '''
                mkdir -p .bin
                if [ ! -f .bin/hadolint ]; then
                    curl -sSfL https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o .bin/hadolint
                    chmod +x .bin/hadolint
                fi

                if [ ! -f .bin/docker ]; then
                    curl -sSfL https://download.docker.com/linux/static/stable/x86_64/docker-27.1.1.tgz | tar -xz -C .bin/ --strip-components=1 docker/docker
                    chmod +x .bin/docker
                fi
                '''
            }
        }
        stage('lint-dockerfile') {
            steps {
                sh 'hadolint Dockerfile'
            }
        }
        stage('test-app') {
            agent {
                docker {
                    image 'golang:1.18' // Use a dedicated Go image for testing
                    // You can specify a different version if needed, e.g., 'golang:1.22'
                }
            }
            steps {
                sh 'go test -v -short --count=1 ./...'
            }
        }
        stage('build-app-karsajobs') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_PAT')]) {
                        sh 'bash build_push_image_karsajobs.sh'
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
