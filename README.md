# SubT Environment Setup
> Ubuntu 18.04 Bionic, ROS Melodic
## Install Minimal dependencies
1. sudo apt install python3-vcstool python-catkin-tools

## Install helper tool and Set up dotfiles (one-time)
2. git clone https://gitlab.robotics.caltech.edu/rollocopter/core/core_environment.git ~/Admin/core_environment
3. pip2 install -e ~/Admin/core_environment --user
4. cd ~/.local/bin && ./subtenv init dotfiles
5. ./subtenv install base

## 
