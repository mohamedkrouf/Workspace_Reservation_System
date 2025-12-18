FROM openjdk:11-jdk-slim
WORKDIR /app
COPY app.war .
EXPOSE 8080
CMD ["java", "-jar", "app.war"]
