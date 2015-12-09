#!/bin/bash

mkdir /tmp/2016-02-09
export ELEX_RECORDING=flat
export ELEX_LOGGING_DIR=/tmp/2016-02-09

dropdb elex
createdb elex
