import datetime
import json
import os

from fabric import api, operations, contrib
from fabric.state import env

PROJECT_NAME = 'elex-loader'
ENVIRONMENTS = {
    "prd": {
        "hosts": [os.environ.get('ELEX_LOADER_PRD_HOST', None)],
    }
}

env.user = "ubuntu"
env.forward_agent = True
env.branch = "master"

env.hosts = ['127.0.0.1']
env.dbs = ['127.0.0.1']
env.settings = None

@api.task
def development():
    """
    Work on development branch.
    """
    env.branch = 'development'

@api.task
def master():
    """
    Work on stable branch.
    """
    env.branch = 'master'

@api.task
def branch(branch_name):
    """
    Work on any specified branch.
    """
    env.branch = branch_name

@api.task
def e(environment):
    env.settings = environment
    env.hosts = ENVIRONMENTS[environment]['hosts']

@api.task
def clone():
    api.run('git clone git@github.com:newsdev/%s.git /home/ubuntu/%s' % (PROJECT_NAME, PROJECT_NAME))

@api.task
def pull():
    api.run('cd /home/ubuntu/%s; git fetch' % PROJECT_NAME)
    api.run('cd /home/ubuntu/%s; git pull origin %s' % (PROJECT_NAME, env.branch))

@api.task
def pip_install():
    api.run('cd /home/ubuntu/%s; workon %s && pip install -r requirements.txt' % (PROJECT_NAME, PROJECT_NAME))

@api.task
def bounce_daemon():
    api.run('sudo service %s restart' % PROJECT_NAME)

@api.task
def deploy():
    pull()
    pip_install()
    bounce_daemon()