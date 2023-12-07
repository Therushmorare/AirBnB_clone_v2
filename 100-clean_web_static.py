#!/usr/bin/python3
"""Fabric script"""

from fabric.api import env, run, local, lcd
from datetime import datetime

env.hosts = ['100.25.19.144', '54.174.251.99']
env.user = 'ubuntu'
env.key_filename = 'my_ssh_private_key'

def do_clean(number=0):
    """Cleans up outdated archives on both web servers"""
    number = int(number)
    if number < 2:
        number = 1
    else:
        number += 1

    local_path = "./versions"
    remote_path = "/data/web_static/releases"

    with lcd(local_path):
        local("ls -1t | tail -n +{} | xargs rm -f".format(number))

    with cd(remote_path):
        run("ls -1t | tail -n +{} | xargs rm -rf".format(number))

def deploy():
    """Example deployment function, modify as needed"""
    # Add your deployment steps here
    pass
