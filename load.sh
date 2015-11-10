dropdb --if-exists elex
createdb elex

psql elex -c "CREATE TABLE races (
    description varchar,
    initialization_data boolean,
    lastupdated varchar,
    national boolean,
    officeid varchar,
    officename varchar,
    party varchar,
    raceid varchar,
    racetype varchar,
    racetypeid varchar,
    seatname varchar,
    seatnum varchar,
    test boolean,
    uncontested boolean
);"

elex init-races 2015-11-03 | psql elex -c "COPY races FROM stdin DELIMITER ',' CSV HEADER;"

