#!/usr/bin/env python
"""OS utilities."""

import distutils.spawn
import logging
import os
import shlex
import shutil
import subprocess
import time


log = logging.getLogger(__name__)


def shell(cmd, cwd=None):
    """Execute shell command."""
    if isinstance(cmd, basestring):
        cmd = shlex.split(cmd)

    log.info("Executing: {}".format(' '.join(cmd)))
    t_start = time.time()
    try:
        p = subprocess.Popen(cmd, cwd=cwd)
    except Exception as e:
        log.error("Execution error: {}".format(e))
        retcode = -1
    else:
        retcode = p.wait()
    t_elapsed = time.time() - t_start
    log.info("Command took {:.1f} secs: {}".format(t_elapsed, ' '.join(cmd)))

    if retcode != 0:
        log.error("Error while executing: {}".format(' '.join(cmd)))
        raise RuntimeError("The program returned non-zero status code")


def get_toplevel_dir():
    """Get root directory for core_environment repository."""
    return os.path.normpath(os.path.join(os.path.dirname(__file__), '..'))


def which(cmd):
    try:
        return shutil.which(cmd)
    except AttributeError:
        return distutils.spawn.find_executable(cmd)
