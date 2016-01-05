#!/bin/bash

mkdir -p /tmp/$RACEDATE

dropdb elex_$RACEDATE
createdb elex_$RACEDATE
