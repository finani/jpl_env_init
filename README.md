# SubT Environment Setup
> Ubuntu 18.04 Bionic
## Install Minimal dependencies
1. sudo apt install python3-vcstool python-catkin-tools

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
7. cd ~/Admin/core_environment
8. git lfs pull
9. subtenv install perception
10. subtenv install ros2
11. subtenv install sim 
```
[WARNING] subtenv.check: [ 0] SubT simulator not found in standard path: /opt/ros/subt
```

## Check your configuration
12. subtenv check

## Update tool
13. subtenv update

## Add new software dependency
If your module needs a new package (typically apt or pip), and want everyone to install onto their system, please edit the package list in shared/apt or shared/pip and make a merge request.
