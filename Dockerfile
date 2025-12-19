FROM tomcat:10-jdk11

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Set working directory
WORKDIR /usr/local/tomcat/webapps

# Copy WAR file as ROOT.war (deploys to root context)
COPY Workspace_Reservation_System.war ROOT.war

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
