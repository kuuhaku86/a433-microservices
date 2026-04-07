pipeline {
    agent any
    environment {
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
        stage('build-app-karsajobs-ui') {
            steps {
                // Menjalankan script build dan push frontend
                sh 'bash build_push_image_karsajobs_ui.sh'
            }
        }
    }
}