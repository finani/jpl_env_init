#!/usr/bin/env python
"""Update subtenv tool."""

import argparse
import glob
import os
import logging
import subprocess
import shlex

from . import check
from .osutil import shell, get_toplevel_dir


log = logging.getLogger(__name__)
verb = 'update'


def get_branch(git_dir):
    """Get git branch."""
    cmd = 'git -C {} rev-parse --abbrev-ref HEAD'.format(git_dir)
    try:
        out = subprocess.check_output(shlex.split(cmd))
    except subprocess.CalledProcessError as e:
        log.error("Error: {}".format(e))
        raise e
    branch = out.decode("utf-8").strip()
    return branch


def main(args):
    log.info("Updating subtenv tool")

    # Check the current branch
    branch = get_branch(get_toplevel_dir())
    log.info("Current branch: %s", branch)
    if branch != 'master':
        log.warn("Target repository is not in master. "
                 "Please update the tool manually.")
        return

    # Should we force master branch?
    shell('git pull', cwd=get_toplevel_dir())


def add_arguments(parser):
    parser.set_defaults(main=main)
    return parser


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    parser = argparse.ArgumentParser()
    add_arguments(parser)
    args = parser.parse_args()
    main(args)
