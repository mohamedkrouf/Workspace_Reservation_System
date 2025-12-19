FROM tomcat:10-jdk11

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file and rename to ROOT.war (this deploys to root context /)
COPY Workspace_Reservation_System.war /usr/local/tomcat/webapps/ROOT.war

# Verify the file exists
RUN ls -lh /usr/local/tomcat/webapps/ && \
    echo "WAR file copied as ROOT.war successfully"

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
