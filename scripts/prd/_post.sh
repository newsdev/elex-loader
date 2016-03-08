function post {
    touch "/home/ubuntu/elex-admin/elex_admin/app.py"
    rm -rf /tmp/delegates_$RACEDATE.csv
    rm -rf /tmp/districts_$RACEDATE.csv
    rm -rf /tmp/results_$RACEDATE.json
}