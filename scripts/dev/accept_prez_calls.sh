#!/bin/bash

. scripts/dev/_racecalls.sh


if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

accept_prez_ap_calls