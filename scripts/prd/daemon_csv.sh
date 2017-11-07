#!/bin/bash
. /home/ubuntu/elex-loader/scripts/prd/_pre.sh
. /home/ubuntu/elex-loader/scripts/prd/_results.sh
# . /home/ubuntu/elex-loader/scripts/prd/_views.sh
. /etc/environment

if [[ ! -z $1 ]] ; then
    RACEDATE=$1
fi

if [ -f /tmp/elex_loader_timeout.sh ]; then
    . /tmp/elex_loader_timeout.sh
fi

if [[ -z $ELEX_LOADER_TIMEOUT ]] ; then
    ELEX_LOADER_TIMEOUT=15
fi

if [[ -z $AP_API_BASE_URL ]] ; then
    AP_API_BASE_URL="http://api.ap.org/v2/"
fi

for (( i=1; i<100000; i+=1 )); do

    echo "0" > /tmp/elex_error.txt

    cd /home/ubuntu/elex-loader/

    if [ -f /tmp/elex_loader_timeout.sh ]; then
        . /tmp/elex_loader_timeout.sh
    fi
    
    echo "=============================================================="
    echo "      START DOWNLOAD CYCLE  $(TZ=America/New_York date)      "
    echo "=============================================================="
    echo " "
    
    echo "------- LOAD CSV WITH TIMEOUT:" $ELEX_LOADER_TIMEOUT"s -------"

    SECONDS=0

    TIMESTAMP=$(date +"%s")

    pre

    echo "ELEX LOADER downloading files."

    echo $AP_API_BASE_URL"/elections/$RACEDATE?apiKey=$AP_NAT_KEY&format=json&level=ru"

    results_csv & PIDRESULTS=$!
    wait $PIDRESULTS

    # while read p; do
    #     if [ $p == "0" ] ; then
    #         echo "Results time elapsed:" $SECONDS"s"
    #         cd /home/ubuntu/election-2017/LATEST/ && npm run post-update "$RACEDATE"
    #         echo "Total time elapsed (A):" $SECONDS"s"
    #     fi
    # done </tmp/elex_error.txt

    while read p; do
        if [ $p == "1" ] ; then
            echo "There was an error downloading the AP results; running post-update."
        fi
    done </tmp/elex_error.txt

    echo "Results time elapsed:" $SECONDS"s"
    cd /home/ubuntu/election-2017/LATEST/ && npm run post-update "$RACEDATE"
    echo "Total time elapsed (A):" $SECONDS"s"

    echo "0" > /tmp/elex_error.txt

    sleep $ELEX_LOADER_TIMEOUT

done
