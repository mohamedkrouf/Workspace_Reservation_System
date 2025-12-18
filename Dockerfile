FROM openjdk:11-jre-slim
WORKDIR /app
COPY app.war .
EXPOSE 8080
CMD ["java", "-jar", "app.war"]

