FROM openjdk:21
COPY poc-01/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
