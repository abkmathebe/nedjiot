FROM openjdk:8-jre-alpine
MAINTAINER Aobakwe Mathebe aobakwe@icloud.com
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","app.jar"]