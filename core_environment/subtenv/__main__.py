#!/usr/bin/env python
"""SubT environment tool entrypoint."""

import argparse
import logging

import subtenv

try:
    import argcomplete
except ImportError:
    pass

try:
    import coloredlogs
except ImportError:
    pass


def main():
    """Main entrypoint."""
    set_logger()
    parser = get_parser()
    parser.set_defaults(main=lambda x: parser.print_help())
    try:
        argcomplete.autocomplete(parser)
    except NameError:
        pass
    args = parser.parse_args()
    return args.main(args)


def get_parser():
    parser = argparse.ArgumentParser(description="SubT environmnet tools")

    subparsers = parser.add_subparsers()
    for cmd in subtenv.commands:
        cmd_parser = subparsers.add_parser(cmd.verb)
        cmd.add_arguments(cmd_parser)
    return parser


def set_logger():
    log_fmt = '[%(levelname)5s] %(name)s: %(message)s'
    try:
        coloredlogs.install(level=logging.INFO, fmt=log_fmt)
    except NameError:
        logging.basicConfig(level=logging.INFO, format=log_fmt)


if __name__ == '__main__':
    main()
