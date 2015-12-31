#!/bin/bash

mkdir -p /tmp/$RACEDATE

dropdb elex
createdb elex
