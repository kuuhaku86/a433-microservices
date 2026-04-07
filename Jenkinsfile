pipeline {
    agent any
    environment {
        GITHUB_PAT = credentials('github-token')
        // Set PATH globally. env.WORKSPACE ensures absolute paths are resolved by Groovy.
        GOROOT = "${env.WORKSPACE}/bin/go"
        GOPATH = "${env.WORKSPACE}/go"
        PATH = "${env.WORKSPACE}/bin/go/bin:${env.WORKSPACE}/bin:${env.PATH}"
    }
    stages {
        stage('setup-tools') {
            steps {
                sh '''
                mkdir -p bin
                if [ ! -f bin/hadolint ]; then
                    curl -sSfL https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o bin/hadolint
                    chmod +x bin/hadolint
                fi
                if [ ! -d bin/go ]; then
                    curl -sSfL https://go.dev/dl/go1.18.linux-amd64.tar.gz | tar -xz -C bin/
                    chmod -R +x bin/go/bin
                fi
                if [ ! -f bin/docker ]; then
                    curl -sSfL https://download.docker.com/linux/static/stable/x86_64/docker-20.10.9.tgz | tar -xz -C bin/ --strip-components=1 docker/docker
                    chmod +x bin/docker
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
            steps {
                sh 'go test -v -short --count=1 ./...'
            }
        }
        stage('build-app-karsajobs') {
            steps {
                sh 'bash build_push_image_karsajobs.sh'
            }
        }
    }
}
