#!/usr/bin/env python


from setuptools import setup, find_packages

setup_opts = {
    'name': 'subtenv',
    'packages': find_packages(),
    'version': '0.0.1',
    'description': 'environment helper for subt',
    'author': 'Kyon Otsu',
    'author_email': 'otsu@jpl.nasa.gov',
    'install_requires': [],
    'entry_points': {
        'console_scripts': [
            'subtenv = subtenv.__main__:main',
        ]
    },
}

setup(**setup_opts)