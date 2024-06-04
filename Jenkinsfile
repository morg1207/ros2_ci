pipeline {
    agent any 
    stages {

        stage('SCM') {
            steps {
                script {
                    properties([pipelineTriggers([pollSCM('* * * * *')])])
                }
                git branch: 'main', url: 'https://github.com/morg1207/ros2_ci.git'
            }
        }
        stage('Clone or Update Repo') {
            steps {
                sh '''
                cd ~/ros2_ws/src
                if [ ! -d "ros2_ci" ]; then
                    git clone https://github.com/morg1207/ros2_ci.git
                    echo 'No existe el repositorio, clonando...'
                else
                    cd ros2_ci
                    git pull origin main
                    echo 'Existe el repositorio, actualizando...'
                fi
                '''
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
                cd ~/ros2_ws/src/ros2_ci 
                sudo docker build -t tortoisebot_ros2_test .
                '''
            }
        }
        stage('Create container') {
            steps {
                
                sh '''
                sudo usermod -aG docker $USER
                newgrp docker
                sudo docker run --rm --name tortoisebot_ros2_container -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix tortoisebot_ros2_test:latest &
                sleep 10
                sudo docker exec tortoisebot_ros2_container /bin/bash -c ". /opt/ros/galactic/setup.bash && cd /ros2_ws && colcon build && . /ros2_ws/install/setup.bash && colcon test --packages-select tortoisebot_waypoints --event-handler=console_direct+ && colcon test-result --all --verbose"
                sudo usermod -aG docker $USER
                newgrp docker
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