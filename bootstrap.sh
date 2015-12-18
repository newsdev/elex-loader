#!/bin/bash

mkdir /tmp/2016-03-01
export ELEX_RECORDING=flat
export ELEX_LOGGING_DIR=/tmp/2016-03-01

dropdb elex
createdb elex
