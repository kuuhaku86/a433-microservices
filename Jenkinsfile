pipeline {
    agent any
    environment {
        // Pastikan Anda telah menambahkan credential 'github-token' di Jenkins
        GITHUB_PAT = credentials('github-token')
    }
    stages {
        stage('lint-dockerfile') {
            steps {
                sh '''
                if ! command -v hadolint &> /dev/null; then
                    curl -sSfL https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o hadolint
                    chmod +x hadolint
                fi
                ./hadolint Dockerfile
                '''
            }
        }
        stage('test-app') {
            steps {
                // Menjalankan unit test backend
                sh 'go test -v -short --count=1 $(go list ./...)'
            }
        }
        stage('build-app-karsajobs') {
            steps {
                // Menjalankan script build dan push yang sudah ada
                sh 'bash build_push_image_karsajobs.sh'
            }
        }
    }
}