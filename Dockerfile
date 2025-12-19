FROM tomcat:10.1-jdk22

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Set working directory
WORKDIR /usr/local/tomcat/webapps

# Copy WAR file with its original name
COPY Workspace_Reservation_System.war Workspace_Reservation_System.war

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
