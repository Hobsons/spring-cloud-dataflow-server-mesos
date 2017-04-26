FROM java:8-alpine
COPY target/spring-cloud-dataflow-server-mesos-1.1.0.BUILD-SNAPSHOT.jar spring-cloud-dataflow-server-mesos.jar"
VOLUME ["/tmp"]
EXPOSE 9393
ENTRYPOINT ["java","-jar","spring-cloud-dataflow-server-mesos.jar"]
