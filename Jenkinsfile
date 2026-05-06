pipeline {
    agent any

    tools {
        jdk 'jdk-21'
        maven 'maven-3'
    }

    environment {
        IMAGE_NAME = "bhavyasri/poc-01"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 'https://github.com/Bhavyasri-Baggi/poc-01.git'
            }
        }

        stage('Build & Test') {
            steps {
                dir('poc-01') {
                    sh 'mvn clean test'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                dir('poc-01') {
                    withSonarQubeEnv('sonarqube-server') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }

        stage('Dependency Check') {
            steps {
                sh '''
                /opt/dependency-check/bin/dependency-check.sh \
                --project poc-01 \
                --scan ./poc-01/target \
                --format HTML \
                --noupdate || true

                '''
            }
        }

        stage('Package') {
            steps {
                dir('poc-01') {
                    sh 'mvn package -DskipTests'
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image $IMAGE_NAME'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                docker stop poc-01 || true
                docker rm poc-01 || true
                docker run -d -p 8081:8080 --name poc-01 $IMAGE_NAME
                '''
            }
        }
    }
}
