# SubT Environment Setup
> Ubuntu 18.04 Bionic

## Install Minimal dependencies
1. sudo apt install python3-vcstool python-catkin-tools python-pip python-argcomplete

## Install helper tool and Set up dotfiles (one-time)
2. git clone https://gitlab.robotics.caltech.edu/rollocopter/core/core_environment.git ~/Admin/core_environment
3. pip2 install -e ~/Admin/core_environment --user
4. cd ~/.local/bin && ./subtenv init dotfiles
5. sudo reboot now

## Install software
6. subtenv install base
```
[WARNING] subtenv.check: [ 0] SubT simulator not found in standard path: /opt/ros/subt
```
7. cd ~/Admin/core_environment && git lfs pull
8. subtenv install perception
9. subtenv install ros2
10. subtenv install sim 
```
[WARNING] subtenv.check: [ 0] SubT simulator not found in standard path: /opt/ros/subt
```

## Check your configuration
11. subtenv check

## Update tool
12. subtenv update

## Add new software dependency
If your module needs a new package (typically apt or pip), and want everyone to install onto their system, please edit the package list in shared/apt or shared/pip and make a merge request.



# Initialize workspace from configuration file

## Create a workspace directory
13. mkdir -p jpl/src
 - mkdir -p <workspace>/src
  
## Initialize ROS workspace overlay (explicit method)
14. cd jpl
 - cd <workspace>
15. catkin config --extend /opt/ros/subt
 - catkin config --extend <workspace_to_overlay>
 - The typical overlay targets are: /opt/ros/melodic, /opt/ros/subt. In general, you should use the latter if it exists.

## Set up workspace
16. cd jpl/src
 - cd <workspace>/src
17. git clone https://gitlab.robotics.caltech.edu/rollocopter/core/core_workspace.git
18. vcs-split-import scout_sim
 -  vcs-split-import <config>
19. catkin build

## Set User Alias
20. gedit ~/.bashrc
```
# Set User Alias
alias eb="gedit ~/.bashrc"
alias sb="source ~/.bashrc"
alias agi="sudo apt-get install"
alias scout_run="~/jpl/src/scout_sim/simulation_scout/launch/start_scout_sim.sh scout"
```
21. source ~/.bashrc



# Useful commands
> Execute the following commands in jpl/src.

## Pull latest code from the servers
1. vcs-pull

## Check the statuses of the repositories
2. vcs-check

## Export current workspace configuration
3. vcs-split-export

## Export current workspace configuration (exactly the same commits)
4. vcs-split-export --exact
