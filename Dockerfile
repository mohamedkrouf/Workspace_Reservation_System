FROM openjdk:11-jre-slim
WORKDIR /app
COPY app.war .
EXPOSE 8080
CMD ["java", "-jar", "app.war"]
```

Commit it.

---

## **Step 3: Create `.dockerignore`**

New file in GitHub:
- Name: `.dockerignore`
- Content:
```
.git
.gitignore
target/
build/
.classpath
.project
.settings/
.DS_Store
