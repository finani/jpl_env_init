# System packages as root for everyone

To install the simulator on a new Ubuntu 18.04 machine (without vagrant):
```
sudo ./install_pkgs_basic.sh
```
This will install the basic packages that are useful on most development machines (vi, emacs, python3, git, etc.) 

Then run:
```
sudo ./install_pkgs_ros.sh
```
The system wide ros/gazebo install is done.

# The subt simulator
Now as your normal user run the following command. It will build the SubT Virtual Testbed as your user and then ask for sudo access to install it in /opt/ros/subt .
```
./system_install_subt_sim.sh
```

To install the nvidia drivers run:
```
./system_install_nvidia.sh
```


Now the simulation environment has been installed.

Individual users should run:
```
./setup_user_ros.sh
```
to the end of their ~/.bashrc file and test the simulator with 
```
roslaunch subt_gazebo competition.launch
```

# Extras 

Docker can be installed with:
```
./system_install_docker.sh
```

Vagrant and VirtualBox can be installed with:
```
./install_pkgs_basic_VM_tools.sh
```

