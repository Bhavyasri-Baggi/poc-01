FROM eclipse-temurin:21-jdk
COPY poc-01/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
