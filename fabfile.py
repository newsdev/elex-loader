import datetime
import json
import os

from fabric import api, operations, contrib
from fabric.state import env

ENVIRONMENTS = {
    "prd": {
        "hosts": [os.environ.get('ELEX_LOADER_PRD_HOST', None)],
    }, 
    "stg": {
        "hosts": [os.environ.get('ELEX_LOADER_STG_HOST', None)]
    }
}

env.project_name = 'elex-loader'
env.user = "ubuntu"
env.forward_agent = True
env.branch = "master"

env.racedate = os.environ.get('RACEDATE', None)
env.hosts = ['127.0.0.1']
env.dbs = ['127.0.0.1']
env.settings = None

@api.task
def r(racedate):
    env.racedate = racedate

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
    api.run('git clone git@github.com:newsdev/%(project_name)s.git /home/ubuntu/%(project_name)s' % env)

@api.task
def pull():
    api.run('cd /home/ubuntu/%(project_name)s; git fetch; git pull origin %(branch)s' % env)

@api.task
def upgrade_elex():
    api.run('cd /home/ubuntu/%(project_name)s; workon %(project_name)s && pip install --upgrade elex' % env)

@api.task
def pip_install():
    api.run('cd /home/ubuntu/%(project_name)s; workon %(project_name)s && pip install -r requirements.txt' % env)

@api.task
def update(racedate=None):
    if racedate:
        env.racedate = racedate
    api.run('export RACEDATE=%(racedate)s; workon %(project_name)s && cd /home/ubuntu/%(project_name)s; ./scripts/%(settings)s/update.sh' % env)

@api.task
def init(racedate=None):
    if racedate:
        env.racedate = racedate
    api.run('export RACEDATE=%(racedate)s; workon %(project_name)s && cd /home/ubuntu/%(project_name)s; ./scripts/%(settings)s/init.sh' % env)


@api.task
def deploy():
    pull()
    pip_install()
