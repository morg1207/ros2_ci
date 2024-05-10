# Start from ROS base image
FROM ros:galactic-ros-base

# Make a catkin workspace
WORKDIR /
RUN mkdir -p /ros2_ws/src
WORKDIR /ros2_ws/src

SHELL [ "/bin/bash" , "-c" ]
# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential

# Install Gazebo 11 and other dependencies
RUN apt-get update && apt-get install -y \
  gazebo11 \
  ros-galactic-gazebo-ros-pkgs \
  ros-galactic-control-msgs \
  ros-galactic-control-toolbox \
  ros-galactic-controller-interface \
  ros-galactic-controller-manager \
  ros-galactic-controller-manager-msgs \
  ros-galactic-joint-state-publisher \
  ros-galactic-robot-state-publisher \
  ros-galactic-robot-localization \
  ros-galactic-xacro \
  ros-galactic-tf2-ros \
  ros-galactic-tf2-tools \
  ros-galactic-gazebo-msgs \
  ros-galactic-gazebo-plugins \
  ros-galactic-gazebo-ros \
  ros-galactic-gazebo-ros2-control \
  ros-galactic-gazebo-ros-pkgs \
  ros-galactic-joint-state-broadcaster \
  ros-galactic-joint-state-publisher \
  ros-galactic-joint-state-publisher-gui \
  ros-galactic-joint-trajectory-controller \
  ros-galactic-rviz2 \
  && rm -rf /var/lib/apt/lists/*

# Create a volume for ROS packages

RUN git clone -b ros2-galactic https://github.com/rigbetellabs/tortoisebot.git /ros2_ws/src/tortoisebot
RUN git clone https://github.com/morg1207/tortoisebot_waypoints.git /ros2_ws/src/tortoisebot/tortoisebot_waypoints

RUN echo 

RUN rm -rf  \ 
    /ros2_ws/src/tortoisebot/tortoisebot_firmware \
    /ros2_ws/src/tortoisebot/tortoisebot_control \ 
    /ros2_ws/src/tortoisebot/tortoisebot_navigation \
    /ros2_ws/src/tortoisebot/tortoisebot_bringup \
    /ros2_ws/src/tortoisebot/tortoisebot_slam \
    /ros2_ws/src/tortoisebot/ydlidar-ros2 

# Build the Catkin workspace
RUN source /opt/ros/galactic/setup.bash \
    && cd /ros2_ws \
    && colcon build

# Ensure the workspace is sourced
RUN echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc

# Set the entry point to start the ROS launch file
ENTRYPOINT ["/bin/bash", "-c", "source /ros2_ws/install/setup.bash && ros2 launch tortoisebot_bringup bringup.launch.py use_sim_time:=True"]