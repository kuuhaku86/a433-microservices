pipeline {
    // 'agent any' means that Jenkins will run the pipeline on any available agent.
    agent any 
    environment {
        // Configure environment variables for the entire pipeline.
        // PATH: Appends custom binary paths within the workspace to the system PATH,
        // making tools like Go and Docker CLI available.
        PATH = "${env.WORKSPACE}/.bin/go/bin:${env.WORKSPACE}/.bin:${env.PATH}"
        // CGO_ENABLED: Disables cgo, preventing Go from linking against C libraries.
        // This is often used when a C compiler (like gcc) is not available on the agent,
        // or to build purely static Go binaries.
        CGO_ENABLED = '0'
    }
    stages {
        stage ('setup-tools') {
            // This stage is responsible for downloading and setting up necessary tools.
            steps {
                sh '''
                # Create a '.bin' directory in the workspace to store downloaded tools.
                mkdir -p .bin
                # Check if Hadolint (Dockerfile linter) executable already exists.
                if [ ! -f .bin/hadolint ]; then
                    # Download Hadolint for Linux (x86_64) from GitHub releases.
                    curl -sSfL https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o .bin/hadolint
                    # Make the downloaded Hadolint executable.
                    chmod +x .bin/hadolint
                fi

                # Check if the Docker CLI executable already exists.
                if [ ! -f .bin/docker ]; then
                    # Download the static Docker CLI binary (version 27.1.1) for Linux.
                    # Then, extract only the 'docker/docker' binary from the tarball into '.bin/'.
                    curl -sSfL https://download.docker.com/linux/static/stable/x86_64/docker-27.1.1.tgz | tar -xz -C .bin/ --strip-components=1 docker/docker
                    # Make the downloaded Docker CLI executable.
                    chmod +x .bin/docker
                fi

                # Check if the Go installation directory already exists.
                if [ ! -d .bin/go ]; then
                    # Inform the user that Go is being downloaded.
                    echo "Downloading Go 1.18.10..."
                    # Download the Go 1.18.10 Linux AMD64 tarball.
                    # Then, extract its contents into the '.bin/' directory, which will create '.bin/go'.
                    curl -sSfL https://go.dev/dl/go1.18.10.linux-amd64.tar.gz | tar -xz -C .bin/
                fi
                '''
            }
        }
        stage('lint-dockerfile') {
            // This stage performs static analysis on the Dockerfile using Hadolint.
            steps {
                sh '''
                # Run Hadolint on the Dockerfile in the current directory.
                hadolint Dockerfile
                '''
            }
        }
        stage('test-app') {
            // This stage runs Go unit tests for the application.
            steps {
                sh 'go test -v -short --count=1 ./...'
            }
        }
        stage('build-app-karsajobs') {
            steps {
                script {
                    // 'withCredentials' block securely injects credentials into the environment.
                    // 'string(credentialsId: 'github-token', variable: 'GITHUB_PAT')' retrieves
                    // a string credential named 'github-token' and makes its value available
                    // as the GITHUB_PAT environment variable within this block.
                    withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_PAT')]) {
                        // Execute a shell script to build and push the Docker image.
                        sh 'bash build_push_image_karsajobs.sh'
                    }
                }
            }
        }
    }
    // 'post' actions are executed after all stages have completed.
    post {
        // 'always' ensures these actions run regardless of the pipeline's success or failure.
        always {
            // Clean up the workspace after each build to ensure a clean state
            deleteDir()
        }
    }
}
