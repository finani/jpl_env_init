#!/usr/bin/env python
"""Install software."""

import argparse
import logging
import os
import platform

from .osutil import get_toplevel_dir


log = logging.getLogger(__name__)
verb = 'check'

errors = []
repo_path = get_toplevel_dir()


def file_contains(filename, statement):
    """Check if file contains a statement."""
    with open(os.path.expanduser(filename)) as f:
        return statement in f.read()


def check_os():
    """Check if it is supported OS version."""
    global errors
    log.info("Checking OS versions")

    # Check OS version
    linux_dist, linux_version, linux_id = platform.linux_distribution()
    msg = 'Unsupported linux distribution: {}'.format(linux_dist, linux_version, linux_id)
    if linux_dist != 'Ubuntu' or linux_id != 'bionic':
        errors.append(msg)

    # Check architecture
    arch = platform.machine()
    if arch not in ['x86_64']:
        errors.append("Unsupported architecture: {}".format(arch))


def check_dotfiles():
    """Check if dotfiles contain source/import statement."""
    global errors

    log.info("Checking dotfiles")

    dotfiles = [
        {
            'filename': '~/.bashrc',
            'search_word': 'shared/dotfiles',
            'error_msg': "Missing 'source {}/shared/dotfiles/.bashrc' in ~/.bashrc"
                         "".format(repo_path),
        },
        {
            'filename': '~/.tmux.conf',
            'search_word': 'shared/dotfiles',
            'error_msg': "Missing 'source {}/shared/dotfiles/.tmux.conf' in ~/.tmux.conf"
                         "".format(repo_path),
        },
        {
            'filename': '~/.vimrc',
            'search_word': 'shared/dotfiles',
            'error_msg': "Missing 'source {}/shared/dotfiles/.vimrc' in ~/.vimrc"
                         "".format(repo_path),
        },
        {
            'filename': '~/.emacs',
            'search_word': 'shared/dotfiles',
            'error_msg': "Missing '(load \"{}/shared/dotfiles/.emacs\")' in ~/.emacs"
                         "".format(repo_path),
        },
    ]

    for df in dotfiles:
        try:
            if not file_contains(df['filename'], df['search_word']):
                errors.append(df['error_msg'])
        except IOError:
            log.warn("File {} not found".format(df['filename']))
            pass


def check_ros():
    """Check ROS installation."""
    global errors

    log.info("Checking ROS installation")

    linux_dist, linux_version, linux_id = platform.linux_distribution()
    ros_distro = os.getenv('ROS_DISTRO')
    if not ros_distro:
        if linux_id == 'bionic':
            ros_distro = 'melodic'
        elif linux_id == 'xenial':
            ros_distro = 'kinetic'

    ros_path = '/opt/ros/{}'.format(ros_distro)
    subt_path = '/opt/ros/subt'

    if not os.path.exists(ros_path):
        errors.append("ROS not found in standard path: {}".format(ros_path))

    if linux_id == 'bionic' and not os.path.exists(subt_path):
        errors.append("SubT simulator not found in standard path: {}".format(subt_path))


def check_database():
    """Check MongoDB installation."""
    global errors

    log.info("Checking MongoDB installation")
    if os.system('systemctl status mongod > /dev/null') != 0:
        errors.append("MongoDB service not started. Check installation and start "
                      "service by `systemctl start mongod`")


def check_shell():
    """Check shell type."""
    global errors

    log.info("Checking shell")
    if os.path.basename(os.environ['SHELL']) != 'bash':
        errors.append("Shell {} is not fully supported. "
                      "Use bash if you encounter problems.".format(os.environ['SHELL']))


def print_errors():
    log.info("Total number of warnings: {}".format(len(errors)))
    for i, err in enumerate(errors):
        log.warn("[{:2d}] {}".format(i, err))


def main(args):
    check_os()
    check_dotfiles()
    check_ros()
    check_database()
    check_shell()
    print_errors()


def add_arguments(parser):
    parser.set_defaults(main=main)
    return parser


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    parser = argparse.ArgumentParser()
    add_arguments(parser)
    args = parser.parse_args()
    main(args)
