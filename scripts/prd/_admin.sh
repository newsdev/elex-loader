function admin {
    . /etc/environment
    . /home/ubuntu/.virtualenvs/elex-admin/bin/activate
    export RACEDATE=$RACEDATE && python /home/ubuntu/elex-admin/elex_admin/initialize_racedate.py
}