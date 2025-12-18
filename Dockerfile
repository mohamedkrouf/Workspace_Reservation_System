FROM tomcat:11-jdk11
WORKDIR /usr/local/tomcat/webapps
COPY Workspace_Reservation_System.war ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
