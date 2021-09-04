FROM openjdk:11
EXPOSE 8080
ADD target/CI-CD-jenkins-docker-integration.jar CI-CD-jenkins-docker-integration.jar
ENTRYPOINT ["java","-jar","/CI-CD-jenkins-docker-integration.jar"]