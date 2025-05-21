FROM openjdk:17-jdk-slim

ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

ENV JAVA_OPTS="-Djavax.net.ssl.trustStore=/app/keystore.p12 -Djavax.net.ssl.trustStorePassword=changeit"

ENTRYPOINT ["java","-jar","/app.jar"]
