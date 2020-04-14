#!/usr/bin/env python
"""Initial setup (e.g., dotfiles)."""

import argparse
import logging
import os
import shutil

from .osutil import shell, get_toplevel_dir

log = logging.getLogger(__name__)
verb = 'init'


# Python 2 and 3 compatibility
try:
    input = raw_input
except NameError:
    pass


def copy_with_backup(src, dst):
    """Copy a file and create backup if target exists."""
    bak = dst + '~'
    has_backup = False

    if os.path.exists(dst):
        # Back up old file
        shutil.copy(dst, bak)
        has_backup = True
        log.info('File {} backed up to {}'.format(dst, bak))

        # Remove old file if it is a symbolic link
        if os.path.islink(dst):
            try:
                os.remove(dst)
            except OSError:
                pass

    # Copy file
    try:
        shutil.copy(src, dst)
    except Exception as e:
        log.error("Error copying file from {} to {}".format(src, dst))

        if has_backup:
            log.info("Backup found. Restoring...")
            shutil.copy(bak, dst)

        raise e


def init_dotfiles():
    """Copy initial dot files to home directory."""
    dotfiles = ['.bashrc', '.vimrc', '.tmux.conf', '.gitconfig', '.clang-format',
                '.emacs', '.config/pycodestyle']
    home_dir = os.path.expanduser('~')
    initial_dir = os.path.join(get_toplevel_dir(), 'shared/dotfiles/initial')

    # Create ~/.config directory
    try:
        os.makedirs(os.path.join(home_dir, '.config'))
    except OSError as e:
        pass

    for df in dotfiles:
        # Prompt user per file
        c = input("Do you want to install {} [y/N]: ".format(df)).strip()
        if c.lower() != 'y':
            log.info("Skipping {}: User cancellation".format(df))
            continue

        # Copy file, create back up if necessary
        ini_file = os.path.join(initial_dir, df)
        tgt_file = os.path.expanduser(os.path.join('~', df))

        try:
            copy_with_backup(ini_file, tgt_file)
        except Exception as e:
            log.error('Failed to initialize {}: {}'.format(df, e))

        # Process file-specific hooks
        if df == '.vimrc':
            init_dotvim()

        if df == '.gitconfig':
            print("git> Please tell me who you are")
            git_email = input("git> user.email?: ").strip()
            git_name = input("git> user.name? : ").strip()
            shell('git config --global user.email {}'.format(git_email))
            shell('git config --global user.name "{}"'.format(git_name))


def init_dotvim():
    """Symlink .vim directory."""
    tgt_dir = os.path.expanduser(os.path.join('~', '.vim'))
    bak_dir = tgt_dir + '~'
    sym_dir = os.path.expanduser(os.path.join(get_toplevel_dir(),
                                              'shared/dotfiles/.vim'))

    # Back up old file
    if os.path.exists(tgt_dir):
        try:
            os.remove(bak_dir)
        except OSError:
            pass
        shutil.move(tgt_dir, bak_dir)
        log.info("Directory {} backed up to {}".format(tgt_dir, bak_dir))

    # Create a symlink
    try:
        os.symlink(sym_dir, tgt_dir)
    except OSError as e:
        log.error('Failed to initialize .vim: {}'.format(df, e))
    else:
        log.info('Directory .vim initialized')


def main(args):
    if args.target == 'dotfiles':
        init_dotfiles()


def add_arguments(parser):
    parser.set_defaults(main=main)
    parser.add_argument('target', choices=['dotfiles'])
    return parser


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    parser = argparse.ArgumentParser()
    add_arguments(parser)
    args = parser.parse_args()
    main(args)
