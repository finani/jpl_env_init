#!/usr/bin/env python
"""Install software."""

import argparse
import glob
import os
import platform
import logging

from . import check
from .osutil import shell, get_toplevel_dir


log = logging.getLogger(__name__)
verb = 'install'

apt_package_list = {}
pip_package_list = {}


def parse_package_list():
    global apt_package_list, pip_package_list
    for lst in glob.glob(os.path.join(get_toplevel_dir(), 'shared/apt/*.list')):
        config, _ = os.path.splitext(os.path.basename(lst))
        apt_package_list[config] = lst
    for lst in glob.glob(os.path.join(get_toplevel_dir(), 'shared/pip/*.list')):
        config, _ = os.path.splitext(os.path.basename(lst))
        pip_package_list[config] = lst


def main(args):
    log.info("Installing {} software".format(args.config))

    # Only support ubuntu 18.04 bionic
    distname, version, code = platform.linux_distribution()
    if distname != 'Ubuntu' or code != 'bionic':
        log.error("This script only supports Ubuntu 18.04 Bionic")
        return

    # Install apt packages
    log.info("Installing apt packages")
    if args.config in apt_package_list:
        prog = os.path.join(get_toplevel_dir(), 'shared/scripts/install_apt_pkgs.sh')
        try:
            shell('sudo {} {}'.format(prog, apt_package_list[args.config]))
        except Exception as e:
            log.error("Failed to install apt packages: %s", e)
            return
    else:
        log.warn("No '{}' config for apt. Skipping".format(args.config))

    # Install pip packages
    log.info("Installing pip packages")
    if args.config in pip_package_list:
        prog = os.path.join(get_toplevel_dir(), 'shared/scripts/install_pip_pkgs.sh')
        try:
            shell('{} {}'.format(prog, pip_package_list[args.config]))
        except Exception as e:
            log.error("Failed to install pip packages: %s", e)
            return
    else:
        log.warn("No '{}' config for pip. Skipping".format(args.config))

    # Setup wireshark group
    log.info("Allowing users in group wireshark to capture")
    prog = "sudo {}".format(os.path.join(get_toplevel_dir(), 'shared/scripts/configure_wireshark.expect'))
    try:
        shell(prog)
    except Exception as e:
        log.error("Failed to reconfigure wireshark-common: %s", e)
        return

    # Setup tshark
    log.info("Setting up permissions for tshark")
    prog = os.path.join(get_toplevel_dir(), 'shared/scripts/setup_tshark_capture.sh')
    try:
        shell(prog)
    except Exception as e:
        log.error("Failed to setup tshark: %s", e)
        return

    # Enable services
    log.info("Set up mongodb")
    try:
        shell('sudo systemctl enable mongod.service')
        shell('sudo systemctl start mongod.service')
    except Exception as e:
        log.error("Failed to start mongod service")
        return

    # Check installation
    check.main(None)


def add_arguments(parser):
    # Initialize package list
    parse_package_list()

    parser.set_defaults(main=main)
    parser.add_argument('config', choices=apt_package_list.keys())
    return parser


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    parser = argparse.ArgumentParser()
    add_arguments(parser)
    args = parser.parse_args()
    main(args)
