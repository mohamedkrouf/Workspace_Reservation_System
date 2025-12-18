<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String contextPath = request.getContextPath();
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - Workspace</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <style>
        .auth-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #ffffff 0%, #f5f5f7 100%);
            padding: 20px;
        }
        
        .auth-card {
            background: white;
            border-radius: 20px;
            padding: 48px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 400px;
            border: 1px solid #e5e5e7;
        }
        
        .auth-card h1 {
            font-size: 32px;
            margin-bottom: 12px;
            text-align: center;
        }
        
        .auth-card p {
            text-align: center;
            color: #86868b;
            margin-bottom: 32px;
            font-size: 15px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            font-size: 14px;
            margin-bottom: 6px;
        }
        
        .btn-submit {
            width: 100%;
            margin-top: 16px;
            padding: 12px;
            font-size: 15px;
        }
        
        .auth-footer {
            text-align: center;
            margin-top: 24px;
            font-size: 14px;
            color: #86868b;
        }
        
        .auth-footer a {
            color: #0071e3;
            text-decoration: none;
        }
        
        .auth-footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <h1>Sign In</h1>
            <p>Access your workspace reservations</p>
            
            <% if (error != null) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>
            
            <% if (success != null) { %>
                <div class="alert alert-success"><%= success %></div>
            <% } %>
            
            <form method="POST" action="<%= contextPath %>/login">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <button type="submit" class="btn btn-primary btn-submit">Sign In</button>
            </form>
            
            <div class="auth-footer">
                Don't have an account? <a href="<%= contextPath %>/register.jsp">Create one</a>
            </div>
            
            <div class="auth-footer" style="margin-top: 16px;">
                <a href="<%= contextPath %>/">← Back to Home</a>
            </div>
        </div>
    </div>
</body>
</html>