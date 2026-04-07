pipeline {
    agent any
    environment {
        GITHUB_PAT = credentials('github-token')
        // Fix "docker: command not found" by adding a local bin directory to the PATH
        PATH = "${workspace}/bin:${env.PATH}"
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
                if [ ! -f bin/docker ]; then
                    curl -sSfL https://download.docker.com/linux/static/stable/x86_64/docker-20.10.9.tgz | tar -xz -C bin/ --strip-components=1 docker/docker
                fi
                '''
            }
        }
        stage('lint-dockerfile') {
            steps {
                // Both binaries are now found automatically in the PATH
                sh 'hadolint Dockerfile'
            }
        }
        stage('build-app-karsajobs-ui') {
            steps {
                // The bash script will now successfully find the docker command
                sh 'bash build_push_image_karsajobs_ui.sh'
            }
        }
    }
}