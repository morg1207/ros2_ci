pipeline {
    agent any 
    stages {
        stage('Create workspace and build') {
            steps {
                sh 'mkdir -p ~/ros2_jenkins_ws/src'
                sh '''
                cd ~/ros2_jenkins_ws
                source /opt/ros/galactic/setup.bash
                colcon build
                '''
            }
        }
        stage('Will check if we need to clone or just pull') {
            steps {
                script {
                    // Cambiar al directorio de trabajo
                    dir('/home/user/ros2_jenkins_ws/src') {
                        echo 'Will check if we need to clone or just pull'
                        // Comprobar si el directorio move_and_turn ya existe
                        if (!fileExists('ros2_ci')) {
                            // Si no existe, clonar el repositorio
                            sh 'git clone https://github.com/morg1207/ros2_ci.git'
                        } else {
                            // Si existe, cambiar al directorio y realizar un pull para actualizar
                            dir('ros2_ci') {
                                sh 'git pull origin master'
                            }
                        }
                    }
                }
            }
        }
        stage(' install and build docker image') {
            steps {
                sh '''
                sudo apt-get update
                sudo apt-get install docker.io docker-compose -y
                sudo service docker start
                sudo usermod -aG docker $USER
                newgrp docker
                cd ~/ros2_jenkins_ws/src/ros2_ci 
                sudo docker build -t tortoisebot_ros2_test .
                '''
            }
        }
        stage('Create container') {
            steps {
                
                sh '''
                sudo usermod -aG docker $USER
                newgrp docker
                sudo docker run --rm --name tortoisebot_ros2_container -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix tortoisebot_test:latest &
                sleep 10
                sudo usermod -aG docker $USER
                newgrp docker
                sudo docker exec tortoisebot_ros2_container /bin/bash -c ". /opt/ros/galactic/setup.bash && . ros2_ws/devel/setup.bash && colcon test --packages-select distance_control --event-handler=console_direct+"

                '''

            }
        }
        stage('Done') {
            steps {
                sleep 2
                sh 'sudo docker rm -f tortoisebot_ros2_container'
                echo 'Pipeline completed'
            }
        }
    }
}