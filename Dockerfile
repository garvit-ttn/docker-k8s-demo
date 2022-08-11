FROM openjdk:8-jdk-alpine
ENV PORT 8080
EXPOSE 8080
COPY target/*.jar /opt/application.jar
WORKDIR /opt
CMD ["java", "-jar", "application.jar"]