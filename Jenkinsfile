pipeline {
    agent any
    environment {
        GITHUB_PAT = credentials('github-token')
        // Define a local path for tools
        PATH = "${workspace}/bin:${env.PATH}"
    }
    stages {
        stage('setup-tools') {
            steps {
                // Install Hadolint and Go binaries locally in the workspace if not present
                sh '''
                mkdir -p bin
                if [ ! -f bin/hadolint ]; then
                    curl -sSfL https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o bin/hadolint
                    chmod +x bin/hadolint
                fi
                if [ ! -d bin/go ]; then
                    curl -sSfL https://go.dev/dl/go1.18.linux-amd64.tar.gz | tar -xz -C bin/
                fi
                '''
            }
        }
        stage('lint-dockerfile') {
            steps {
                sh '''
                export PATH="${workspace}/bin/go/bin:${workspace}/bin:${PATH}"
                hadolint Dockerfile
                '''
            }
        }
        stage('test-app') {
            steps {
                sh '''
                export PATH="${workspace}/bin/go/bin:${workspace}/bin:${PATH}"
                go test -v -short --count=1 $(go list ./...)
                '''
            }
        }
        stage('build-app-karsajobs') {
            steps {
                sh 'bash build_push_image_karsajobs.sh'
            }
        }
    }
}
