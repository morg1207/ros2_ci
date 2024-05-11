# STEPS TO TEST TORTOISEBOT AND WAYPOINTS FOR ROS2

### Access Jenkins
```console
cd 
source run_jenkins.sh
cat jenkins__pid__url.txt
```
### Access the Jenkins URL and log in with the following credentials:
```
Username: user
Password: s@mmd7ca91
```
### Build Jenkins
```
Enter the following job: tortoisebot_cli_ros2
Build the job
```

# How to push changes into the repository

Now, you can change something in the code. For example:

```console
cd ~/ros2_ws/src/ros2_ci
echo "jenkins" > file_to_test.txt
```

Execute these steps in the command line interface:

```console
git add .
git commit -m "Created file to test"
git push origin mater