SubT Environment Setup
======================

This repository contains the tools to start up your development. 


## Supported platforms

We currently support two versions of ubuntu:
- ~~Ubuntu 16.04 Xenial~~
- Ubuntu 18.04 Bionic

~~In the future, it is likely that we stop supporting Xenial. It is recommended to use Bionic if possible.~~
Ubuntu 16.04 Xenial is not supported anymore.


## Usage

### Install helper tool (one-time)
Checkout this repository to `~/Admin/core_environment`. If you already have it, remove the old one and replace.
```shell
git clone https://gitlab.robotics.caltech.edu/rollocopter/core/core_environment.git ~/Admin/core_environment
```

Install the helper tool by:
```
pip2 install -e ~/Admin/core_environment --user
```
This command will install `subtenv` command to `~/.local/bin`. Make sure you have set `PATH` to the location.


### Set up dotfiles (one-time)
We have common dotfiles for bash, tmux, git, etc. Type the following to set up:
```shell
subtenv init dotfiles
```

Your old files will be backup with suffix `~`. You may want to copy/paste some of the entries to keep your custom set-up.


### Install software
**Only do this process if you have time. The software installation might temporary break your system.**

To install dependent software, type
```shell
subtenv install base
```
After this step and before you call another subtenv install, run this:
```shell
cd ~/Admin/core_environment
git lfs pull
```

Then you can continue:
```shell
subtenv install perception
subtenv install ros2
subtenv install sim
```

If the program successfully finishes, reboot the machine. If you encounter any problems, contact @otsu or @jedlund.


### Check your configuration
You can use the following command to identify the installation problem. Note that this is work in progress and does not cover everything (yet).
```shell
subtenv check
```


### Update tool
To get the latest version of `subtenv`, type
```shell
subtenv update
```


## Add new software dependency
If your module needs a new package (typically apt or pip), and want everyone to install onto their system, please edit the package list in [shared/apt](shared/apt) or [shared/pip](shared/pip) and make a merge request.

