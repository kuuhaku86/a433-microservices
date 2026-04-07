pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: golang
    image: golang:1.18
    command: ['cat']
    tty: true
  - name: docker
    image: docker:latest
    command: ['cat']
    tty: true
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock
'''
        }
    }
    environment {
        GITHUB_PAT = credentials('github-token')
    }
    stages {
        stage('lint-dockerfile') {
            steps {
                container('golang') {
                    sh '''
                    if ! command -v hadolint &> /dev/null; then
                        curl -sSfL https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o hadolint
                        chmod +x hadolint
                    fi
                    ./hadolint Dockerfile
                    '''
                }
            }
        }
        stage('test-app') {
            steps {
                container('golang') {
                    sh 'go test -v -short --count=1 $(go list ./...)'
                }
            }
        }
        stage('build-app-karsajobs') {
            steps {
                container('docker') {
                    sh 'bash build_push_image_karsajobs.sh'
                }
            }
        }
    }
}
