FROM eclipse-temurin:11-jre
WORKDIR /app
COPY Workspace_Reservation_System.war app.war
EXPOSE 8080
CMD ["java", "-jar", "app.war"]
