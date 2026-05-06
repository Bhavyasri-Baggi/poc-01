pipeline {
    agent any

    tools {
        jdk 'jdk-21'
        maven 'maven-3'
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

        stage('Package') {
            steps {
                dir('poc-01') {
                    sh 'mvn package -DskipTests'
                }
            }
        }
    }
}
