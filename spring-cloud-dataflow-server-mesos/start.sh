#!/bin/sh
#===============================================================================
# Run Spring dataflow server
#===============================================================================

set -x
env

#SPRING_OPTIONS="--spring.datasource.url=jdbc:postgresql://spring-dataflow-db:5432/dataflowdb \
#    --spring.datasource.username=$PG_USER \
#    --spring.datasource.password=$PG_PASSWORD \
#    --spring.datasource.driver-class-name=org.postgresql.Driver"

waitUntilDBStarted(){
    local responseCode=-1
    until [[ ${responseCode} -eq 0 ]]; do
        nc -z $DB_HOST $DB_PORT < /dev/null
        responseCode=$?
        sleep 5
    done
}

if [ -z ${DB_HOST} ]
then
    DB_HOST=$(echo $SF_spring_datasource_url | cut -d/ -f3 | cut -d: -f1 | cut -d/ -f1 )
    DB_PORT=$(echo $SF_spring_datasource_url | cut -d: -f4 | cut -d/ -f1)
fi

if [ -z $DB_PORT ]
then
    DB_PORT=5432
fi
waitUntilDBStarted

#===============================================================================
# Get a list of all SF_ variables and convert them to spring variables
#===============================================================================
envVars=$(env | grep ^SF_)
for i in ${envVars}; do
	envVar="${i/SF_/}"
	envVar="${envVar//_/.}"
	SPRING_OPTIONS="$SPRING_OPTIONS --$envVar"
done

echo java -cp "post*.jar" -jar spring-cloud-dataflow-server-mesos.jar $SPRING_OPTIONS
java -cp "post*.jar" -jar spring-cloud-dataflow-server-mesos.jar $SPRING_OPTIONS

