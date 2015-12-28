#!/bin/bash

mkdir -p /tmp/2016-02-01
export ELEX_RECORDING=flat
export ELEX_LOGGING_DIR=/tmp/2016-02-01

dropdb elex
createdb elex
