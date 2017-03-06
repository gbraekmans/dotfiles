#!/usr/bin/env python
from __future__ import print_function

from glob import glob
from subprocess import Popen, PIPE
import argparse
import os
import pickle
import sys
import time

import xdg.BaseDirectory
from xdg.DesktopEntry import DesktopEntry


def eprint(*args, **kwargs):
    """
    Print something to stderr
    """
    print(*args, file=sys.stderr, **kwargs)


def find_desktop_files(debug_enabled):
    """
    Returns a list of all application .desktop files.
    This list respects the precedence rules, the first one overrules later
    defined ones.
    """
    desktop_files = list()
    for data_directory in xdg.BaseDirectory.xdg_data_dirs:
        application_directory = data_directory + '/applications'
        for application in glob(application_directory + "/*.desktop"):
            desktop_files.append(application)
            if debug_enabled:
                eprint("FOUND: " + application)
    return desktop_files


def parse(desktop_file, debug_enabled):
    """
    Returns a dict if the .desktop entry should be included in the dmenu, or
    none if not applicable
    """
    application = DesktopEntry(desktop_file)
    if debug_enabled:
        eprint('PARSED: ' + desktop_file)
    if application.getHidden():
        if debug_enabled:
            eprint('HIDDEN: ' + desktop_file)
        return None
    if application.getNoDisplay():
        if debug_enabled:
            eprint('NODISPLAY: ' + desktop_file)
        return None
    executable = application.getTryExec()
    if not executable:
        executable = application.getExec()
    if not executable:
        if debug_enabled:
            eprint('NO EXECUTABLE: ' + desktop_file)
        return None
    return {application.getName(): executable.split(' ')[0]}


def desktop_file_identifier(desktop_file):
    """
    Returns the unique portion of the desktop file path.

    >>> desktop_file_identifier('~/.local/share/applications/test.desktop')
    test.desktop
    >>> desktop_file_identifier('/usr/share/applications/test.desktop')
    test.desktop
    """
    return desktop_file.split('/')[-1]


def build_cache(cache_path, debug_enabled):
    """
    Builds a cache of all desktop files in XDG cache directory
    """
    if debug_enabled:
        eprint('(RE)BUILDING CACHE')
    # Build list of valid applications
    applications = dict()
    parsed_applications = set()

    for desktop_file in find_desktop_files(debug_enabled):

        # Skip already parsed desktop files
        if desktop_file_identifier(desktop_file) in parsed_applications:
            if debug_enabled:
                eprint('SKIP PARSING: ' + desktop_file)
            continue
        parsed_applications.add(desktop_file_identifier(desktop_file))

        # Parse the desktop_file
        application = parse(desktop_file, debug_enabled)
        if application:
            applications.update(application)
            if debug_enabled:
                eprint('ADDED: ' + desktop_file)
    with open(cache_path, 'w') as cache:
        pickle.dump(applications, cache)


def main():
    # Set up the argument parser
    parser = argparse.ArgumentParser(description='dmenu for .desktop files')
    parser.add_argument('-m', '--dmenu', default='dmenu -i',
                        help='Replace dmenu with this command')
    parser.add_argument('-c', '--cache', default=60,
                        help='Minutes after which the cache becomes invalid',
                        type=int)
    parser.add_argument('-d', '--debug', help='Show debug log',
                        action='store_true')
    args = parser.parse_args()

    # Try to load data from cache rebuild if needed
    cache_path = xdg.BaseDirectory.save_cache_path('xdg_dmenu') + '/mnu.pickle'
    if not os.path.exists(cache_path):
        build_cache(cache_path, args.debug)
    cache_mtime = os.stat(cache_path).st_mtime
    now = time.time()
    if (now - cache_mtime) > 60 * int(args.cache):
        if args.debug:
            eprint('CACHE IS OUT OF DATE: %d seconds' % (now - cache_mtime))
        build_cache(cache_path, args.debug)
    with open(cache_path, 'r') as cache:
        applications = pickle.load(cache)

    # Show dmenu
    dmenu = Popen(args.dmenu, shell=True, stdout=PIPE, stdin=PIPE, stderr=PIPE)
    stdout = dmenu.communicate(input='\n'.join(applications.keys()))[0]
    selected_application = stdout.strip('\n')

    # Launch the selected application
    if selected_application in applications:
        if args.debug:
            eprint('STARTING: ' + applications[selected_application])
        Popen(applications[selected_application])


if __name__ == '__main__':
    main()
