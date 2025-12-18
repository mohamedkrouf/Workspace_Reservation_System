FROM eclipse-temurin:11-jre
WORKDIR /app
COPY app.war .
EXPOSE 8080
CMD ["java", "-jar", "app.war"]
