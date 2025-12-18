<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Object user = session.getAttribute("user");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Workspace - Book Your Focus Room</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
    <!-- NAVBAR -->
    <div class="navbar">
        <strong>Workspace</strong>
        <div>
            <% if (user != null) { %>
                <a href="<%= contextPath %>/dashboard.jsp">Dashboard</a>
                <a href="<%= contextPath %>/rooms">Rooms</a>
                <a href="<%= contextPath %>/logout">Logout</a>
            <% } else { %>
                <div class="btn-group">
                    <a href="<%= contextPath %>/login.jsp" class="btn btn-secondary">Sign In</a>
                    <a href="<%= contextPath %>/register.jsp" class="btn btn-primary">Sign Up</a>
                </div>
            <% } %>
        </div>
    </div>

    <!-- HERO SECTION -->
    <section class="hero">
        <div style="margin-bottom: 40px;">
            <h1>Spaces engineered for deep focus</h1>
            <p>Workspaces designed using behavioral science and real productivity data.</p>
        </div>
        <img src="<%= contextPath %>/images/workspace.jpg" alt="Workspace">
    </section>

    <!-- BACKED BY SCIENCE -->
    <section class="container">
        <h2>Backed by Science</h2>
        <div class="card-grid">
            <div class="card">
                <h3>47% Fewer Distractions</h3>
                <p>Studies show isolated workspaces increase sustained attention by nearly half.</p>
            </div>
            <div class="card">
                <h3>2.1x Deep Work Sessions</h3>
                <p>Users complete more uninterrupted focus sessions compared to open offices.</p>
            </div>
            <div class="card">
                <h3>Lower Cognitive Fatigue</h3>
                <p>Minimalist environments reduce mental load and decision fatigue.</p>
            </div>
        </div>
    </section>

    <!-- ROOM SHOWCASE -->
    <section class="container">
        <h2>Our Workspace Rooms</h2>
        <div class="card-grid">
            <% 
                String[] roomNames = {"science", "aaa", "bbb", "workspace"};
                String[] roomTitles = {"Focus Zone", "Collaboration Space", "Creative Studio", "Executive Suite"};
                String[] roomDescriptions = {
                    "Designed for individual deep work and concentration.",
                    "Perfect for team meetings and collaborative projects.",
                    "Inspiring environment for creative brainstorming.",
                    "Premium workspace for important presentations."
                };
                
                for (int i = 0; i < roomNames.length; i++) {
            %>
                <div class="card">
                    <img height=200px src="<%= contextPath %>/images/<%= roomNames[i] %>.jpg" alt="<%= roomTitles[i] %>">
                    <h3><%= roomTitles[i] %></h3>
                    <p><%= roomDescriptions[i] %></p>
                    <% if (user != null) { %>
                        <a href="<%= contextPath %>/rooms" class="btn btn-primary btn-small">Book Now</a>
                    <% } else { %>
                        <a href="<%= contextPath %>/login.jsp" class="btn btn-primary btn-small">Sign In to Book</a>
                    <% } %>
                </div>
            <% } %>
        </div>
    </section>

    <!-- TESTIMONIALS -->
    <section class="container">
        <h2>What Others Are Saying</h2>
        <div class="card-grid">
            <div class="card">
                <img src="<%= contextPath %>/images/person1.jpg" alt="Remote Engineer">
                <p>"I have never been this consistent with my work."</p>
                <strong>— Remote Engineer</strong>
            </div>
            <div class="card">
                <img src="<%= contextPath %>/images/person2.jpg" alt="Startup Founder">
                <p>"This feels like a library built for modern creators."</p>
                <strong>— Startup Founder</strong>
            </div>
        </div>
    </section>

    <!-- CTA SECTION -->
    <% if (user == null) { %>
        <section class="container" style="text-align: center;">
            <h2>Ready to Transform Your Workspace?</h2>
            <p style="font-size: 18px; color: var(--text-secondary); margin-bottom: 32px;">Join hundreds of professionals who found their focus.</p>
            <a href="<%= contextPath %>/register.jsp" class="btn btn-primary" style="padding: 14px 32px; font-size: 17px;">Get Started Free</a>
        </section>
    <% } %>

    <!-- FOOTER -->
    <footer>
        <div class="container">
            <div class="card-grid">
                <div>
                    <h3>Workspace</h3>
                    <p>Designing calm environments for deep work and peak productivity.</p>
                </div>
                <div>
                    <strong>Product</strong>
                    <a href="<%= contextPath %>/rooms">Rooms</a>
                    <a href="#">Pricing</a>
                    <a href="#">FAQ</a>
                </div>
                <div>
                    <strong>Company</strong>
                    <a href="#">About</a>
                    <a href="#">Careers</a>
                    <a href="#">Contact</a>
                </div>
            </div>
            <p style="margin-top: 40px; font-size: 13px;">
                © 2024 Workspace. All statements are illustrative for educational purposes.
            </p>
        </div>
    </footer>
</body>
</html>