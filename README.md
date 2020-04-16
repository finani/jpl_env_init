# SubT Environment Setup
> Ubuntu 18.04 Bionic

## Install Minimal dependencies
1. sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
2. sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xAB17C654
3. sudo apt-get update
4. sudo apt install python3-vcstool python-catkin-tools python-pip python-argcomplete

## Install helper tool and Set up dotfiles (one-time)
5. sudo apt-get install git-all
6. git clone https://gitlab.robotics.caltech.edu/rollocopter/core/core_environment.git ~/Admin/core_environment
7. pip2 install -e ~/Admin/core_environment --user
8. cd ~/.local/bin && ./subtenv init dotfiles
9. sudo reboot now

## Install software
10. subtenv install base
```
[WARNING] subtenv.check: [ 0] SubT simulator not found in standard path: /opt/ros/subt
```
11. cd ~/Admin/core_environment && git lfs pull
12. subtenv install perception
13. subtenv install ros2
14. subtenv install sim 
```
[WARNING] subtenv.check: [ 0] SubT simulator not found in standard path: /opt/ros/subt
```
15. sudo reboot now

## Check your configuration
16. subtenv check

## Update tool
17. subtenv update

## Add new software dependency
If your module needs a new package (typically apt or pip), and want everyone to install onto their system, please edit the package list in shared/apt or shared/pip and make a merge request.



# Initialize workspace from configuration file

## Create a workspace directory
18. mkdir -p jpl/src
 - mkdir -p <_workspace_>/src
  
## Initialize ROS workspace overlay (explicit method)
19. cd ~/jpl
 - cd <_workspace_>
20. catkin config --extend /opt/ros/subt
 - catkin config --extend <_workspace_to_overlay_>
 - The typical overlay targets are: /opt/ros/melodic, /opt/ros/subt. In general, you should use the latter if it exists.

## Set up workspace
21. cd ~/jpl/src
 - cd <_workspace_>/src
22. git clone https://gitlab.robotics.caltech.edu/rollocopter/core/core_workspace.git
23. vcs-split-import scout_sim
 -  vcs-split-import <_config_>
24. catkin build

## Set User Alias
25. gedit ~/.bashrc
```
source ~/jpl/devel/setup.bash

# Set User Alias
alias eb="gedit ~/.bashrc"
alias sb="source ~/.bashrc"
alias agi="sudo apt-get install"
alias scout_run="~/jpl/src/scout_sim/simulation_scout/launch/start_scout_sim.sh scout"
```
26. source ~/.bashrc
27. scout_run
```
libgazebo_multirotor_base_plugin.so
libgazebo_motor_model.so
libgazebo_gps_plugin.so
libgazebo_mavlink_interface.so
libgazebo_imu_plugin.so
```

### 1st error
Command 'roslaunch' not found, but can be installed with:
sudo apt install python-roslaunch

- gedit ~/.bashrc
```
source ~/jpl/devel/setup.bash
```

### 2nd error


~/jpl/src/scout_core/core_capability/bringup_gazebo/launch/spawn_scout.launch
~/jpl/src/scout_core/core_robot_model/scout_description/launch/description.launch
/usr/share/gazebo/setup.sh



# Useful commands
> Execute the following commands in jpl/src (<_workspace_>/src).

## Pull latest code from the servers
1. vcs-pull

## Check the statuses of the repositories
2. vcs-check

## Export current workspace configuration
3. vcs-split-export

## Export current workspace configuration (exactly the same commits)
4. vcs-split-export --exact
