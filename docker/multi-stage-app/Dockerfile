FROM alpine:latest as builder

WORKDIR /project

COPY pom.xml /project
COPY /src /project/src

RUN apk add --update maven openjdk8

RUN mvn package

#RUN ls
#CMD ["ls -la"]

FROM tomcat:9-jre8-alpine

COPY --from=builder /project/target/*.jar /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat/webapps/

EXPOSE 8080

# Comando que se ejecuta al hacer docker run
RUN java -jar java-webapp-0.0.1.jar
