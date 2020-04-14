# SubT Environment Setup
> Ubuntu 18.04 Bionic, ROS Melodic
## Install Minimal dependencies
1. sudo apt install python3-vcstool python-catkin-tools

## Install helper tool and Set up dotfiles (one-time)
2. git clone https://gitlab.robotics.caltech.edu/rollocopter/core/core_environment.git ~/Admin/core_environment
3. pip2 install -e ~/Admin/core_environment --user
4. cd ~/.local/bin && ./subtenv init dotfiles

## Install software
5. cd ~/.local/bin && ./subtenv install base
'''
[WARNING] subtenv.check: [ 0] SubT simulator not found in standard path: /opt/ros/subt
'''
6. cd ~/Admin/core_environment
7. git lfs pull
8. subtenv install perception
9. subtenv install ros2
10. subtenv install sim

## Check your configuration
11. cd ~/.local/bin && ./subtenv check

## Update tool
12. cd ~/.local/bin && ./subtenv update

## Add new software dependency
If your module needs a new package (typically apt or pip), and want everyone to install onto their system, please edit the package list in shared/apt or shared/pip and make a merge request.
