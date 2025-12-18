<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%
    Object userObj = session.getAttribute("user");
    Object roleObj = session.getAttribute("role");
    if (userObj == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    User user = (User) userObj;
    String contextPath = request.getContextPath();
    boolean isAdmin = "ADMIN".equals(roleObj);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Workspace</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <style>
        .dashboard-header {
            padding: 60px 40px;
            background: linear-gradient(135deg, #ffffff 0%, #f5f5f7 100%);
        }
        
        .welcome-section h1 {
            font-size: 48px;
            margin-bottom: 8px;
        }
        
        .welcome-section p {
            font-size: 18px;
            color: #86868b;
        }
        
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 40px;
        }
        
        .action-card {
            background: white;
            padding: 24px;
            border-radius: 12px;
            border: 1px solid #e5e5e7;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .action-card:hover {
            border-color: #0071e3;
            box-shadow: 0 6px 20px rgba(0, 113, 227, 0.2);
        }
        
        .action-card h3 {
            margin-bottom: 8px;
        }
        
        .action-card p {
            font-size: 14px;
            color: #86868b;
            margin-bottom: 16px;
        }
        
        @media (max-width: 768px) {
            .dashboard-header {
                padding: 40px 20px;
            }
            
            .welcome-section h1 {
                font-size: 32px;
            }
        }
    </style>
</head>
<body>
    <!-- NAVBAR -->
    <div class="navbar">
        <strong>Workspace</strong>
        <div>
            <a href="<%= contextPath %>/">Home</a>
            <a href="<%= contextPath %>/rooms">Browse Rooms</a>
            <% if (isAdmin) { %>
                <a href="<%= contextPath %>/admin" style="color: #0071e3; font-weight: 600;">Admin Dashboard</a>
            <% } %>
            <a href="<%= contextPath %>/logout" class="navbar-link">Logout</a>
        </div>
    </div>

    <!-- WELCOME SECTION -->
    <div class="dashboard-header">
        <div class="welcome-section">
            <h1>Welcome back, <%= user.getName() %></h1>
            <p>Book your next focused work session</p>
        </div>
        
        <div class="quick-actions">
            <a href="<%= contextPath %>/rooms" class="action-card" style="text-decoration: none; color: inherit;">
                <h3>🎯 Book a Room</h3>
                <p>Reserve your next workspace session</p>
                <div class="btn btn-primary btn-small">Browse Rooms</div>
            </a>
            
            <div class="action-card">
                <h3>📊 My Reservations</h3>
                <p>View and manage your bookings</p>
                <a href="<%= contextPath %>/my-reservations.jsp" class="btn btn-secondary btn-small" style="text-decoration: none;">View Details</a>
            </div>
            
            <div class="action-card">
                <h3>👤 My Profile</h3>
                <p><%= user.getEmail() %></p>
                <button class="btn btn-secondary btn-small" style="cursor: not-allowed;">Coming Soon</button>
            </div>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <section class="container">
        <h2>Your Workspace Features</h2>
        <div class="card-grid">
            <div class="card">
                <h3>🔐 Secure Booking</h3>
                <p>Your reservations are protected with secure authentication and real-time updates.</p>
            </div>
            <div class="card">
                <h3>⚡ Instant Confirmation</h3>
                <p>Get immediate confirmation for your room bookings with calendar integration.</p>
            </div>
            <div class="card">
                <h3>🔔 Smart Notifications</h3>
                <p>Receive reminders before your sessions and updates on room availability.</p>
            </div>
        </div>
    </section>

    <!-- RESERVATIONS SECTION -->
    <section id="reservations" class="container">
        <h2>Getting Started</h2>
        <div class="card-grid">
            <div class="card">
                <h3>Step 1: Browse Rooms</h3>
                <p>Explore our collection of carefully designed workspaces, each optimized for different types of work.</p>
            </div>
            <div class="card">
                <h3>Step 2: Select Time</h3>
                <p>Choose your preferred date and time. Our system ensures no double-bookings and prevents scheduling conflicts.</p>
            </div>
            <div class="card">
                <h3>Step 3: Confirm & Enjoy</h3>
                <p>Complete your reservation and start your focused work session in a distraction-free environment.</p>
            </div>
        </div>
    </section>

    <!-- CTA SECTION -->
    <section class="container" style="text-align: center; padding: 80px 40px;">
        <h2>Ready to Book?</h2>
        <p style="font-size: 18px; color: #86868b; margin-bottom: 32px;">Browse our available rooms and reserve your perfect focus space.</p>
        <a href="<%= contextPath %>/rooms" class="btn btn-primary" style="padding: 14px 32px; font-size: 17px;">View All Rooms</a>
    </section>

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
                    <strong>Support</strong>
                    <a href="#">Help Center</a>
                    <a href="#">Contact</a>
                    <a href="#">Status</a>
                </div>
            </div>
            <p style="margin-top: 40px; font-size: 13px;">
                © 2024 Workspace. All rights reserved.
            </p>
        </div>
    </footer>
</body>
</html>