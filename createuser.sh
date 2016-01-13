#!/bin/bash

date "+STARTED: %H:%M:%S"
echo "------------------------------"

echo "Create elex role"
psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='elex'" | grep -q 1 || createuser elex

echo "Make elex a superuser"
psql postgres -tAc "alter user elex with superuser;"

echo "------------------------------"
date "+ENDED: %H:%M:%S"
