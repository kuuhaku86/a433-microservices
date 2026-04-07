pipeline {
    agent { 
        docker { 
            image 'golang:1.18'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        } 
    }
    environment {
        GITHUB_PAT = credentials('github-token')
    }
    stages {
        stage('lint-dockerfile') {
            steps {
                sh '''
                curl -sSfL https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o /usr/local/bin/hadolint
                chmod +x /usr/local/bin/hadolint
                hadolint Dockerfile
                '''
            }
        }
        stage('test-app') {
            steps {
                sh 'go test -v -short --count=1 $(go list ./...)'
            }
        }
        stage('build-app-karsajobs') {
            steps {
                sh 'bash build_push_image_karsajobs.sh'
            }
        }
    }
}
