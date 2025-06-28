pipeline {
    agent any
    parameters {
        choice(name: 'OS', choices: ['Linux', 'Darwin', 'MINGW'], description: 'Target Operating System')
        choice(name: 'ARCH', choices: ['x86_64', 'arm64', 'aarch64'], description: 'Target Architecture')
    }
    environment {
        APP_NAME = sh(script: "basename \$(git remote get-url origin) | sed 's/\\.git\$//'", returnStdout: true).trim()
        GIT_REPO = "github.com/svvpro/test-bot"
        REGYSTRY = "svvpro"
        VERSION = sh(script: "git describe --tags --abbrev=0)-\$(git rev-parse --short HEAD)", returnStdout: true).trim()
        
        // Map OS and ARCH to Docker-compatible values
        DOCKER_OS = "${OS == 'Linux' ? 'linux' : OS == 'Darwin' ? 'linux' : OS == 'MINGW' ? 'windows' : error('Unsupported OS: ' + OS)}"
        DOCKER_ARCH = "${ARCH == 'x86_64' ? 'amd64' : ARCH == 'arm64' || ARCH == 'aarch64' ? 'arm64' : error('Unsupported architecture: ' + ARCH)}"
        PLATFORM = "${DOCKER_OS}/${DOCKER_ARCH}"
    }
    
    stages {
        stage('Format') {
            steps {
                sh 'make format'
            }
        }
        
        stage('Get Dependencies') {
            steps {
                sh 'make get'
            }
        }
        
        stage('Lint') {
            steps {
                sh 'make lint'
            }
        }
        
        stage('Test') {
            steps {
                sh 'make test'
            }
        }
        
        stage('Build') {
            parallel {
                stage('Linux-amd64') {
                    when {
                        expression { params.OS == 'Linux' && params.ARCH == 'x86_64' }
                    }
                    steps {
                        sh 'make linux'
                    }
                }
                
                stage('Linux-arm64') {
                    when {
                        expression { params.OS == 'Linux' && (params.ARCH == 'arm64' || params.ARCH == 'aarch64') }
                    }
                    steps {
                        sh 'make linux-arm'
                    }
                }
                
                stage('MacOS-amd64') {
                    when {
                        expression { params.OS == 'Darwin' && params.ARCH == 'x86_64' }
                    }
                    steps {
                        sh 'make macos'
                    }
                }
                
                stage('MacOS-arm64') {
                    when {
                        expression { params.OS == 'Darwin' && (params.ARCH == 'arm64' || params.ARCH == 'aarch64') }
                    }
                    steps {
                        sh 'make macos-arm'
                    }
                }
                
                stage('Windows-amd64') {
                    when {
                        expression { params.OS == 'MINGW' && params.ARCH == 'x86_64' }
                    }
                    steps {
                        sh 'make windows'
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh 'make image'
            }
        }
        
        stage('Push Docker Image') {
            steps {
                sh 'make push'
            }
        }
    }
    
    post {
        always {
            sh 'make clean'
        }
    }
}