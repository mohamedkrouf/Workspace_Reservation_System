<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.Room, model.Reservation, model.User" %>
<%@ page import="dao.AdminDAO" %>
<%
    Object userObj = session.getAttribute("user");
    Object roleObj = session.getAttribute("role");
    if (userObj == null || !"ADMIN".equals(roleObj)) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }
    
    String contextPath = request.getContextPath();
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Workspace</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <style>
        .admin-navbar {
            background: #1d1d1f;
            border-bottom: 1px solid #424245;
        }
        
        .admin-navbar strong,
        .admin-navbar a {
            color: #f5f5f7;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: white;
            padding: 24px;
            border-radius: 12px;
            border: 1px solid #e5e5e7;
            text-align: center;
        }
        
        .stat-number {
            font-size: 36px;
            font-weight: 700;
            color: #0071e3;
            margin-bottom: 8px;
        }
        
        .stat-label {
            font-size: 14px;
            color: #86868b;
        }
        
        .tabs {
            display: flex;
            gap: 20px;
            border-bottom: 1px solid #e5e5e7;
            margin-bottom: 32px;
        }
        
        .tab {
            padding: 12px 0;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            color: #86868b;
            transition: all 0.3s ease;
        }
        
        .tab.active {
            color: #0071e3;
            border-bottom-color: #0071e3;
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        .form-inline {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
            align-items: flex-end;
        }
        
        .form-inline .btn {
            height: 40px;
        }
        
        .actions {
            display: flex;
            gap: 8px;
        }
        
        .actions .btn {
            padding: 6px 12px;
            font-size: 13px;
        }
        
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
        }
        
        .dashboard-header h1 {
            margin: 0;
        }
    </style>
</head>
<body>
    <!-- NAVBAR -->
    <div class="navbar admin-navbar">
        <strong>Workspace Admin</strong>
        <div>
            <a href="<%= contextPath %>/">Home</a>
            <a href="<%= contextPath %>/dashboard.jsp">User Dashboard</a>
            <a href="<%= contextPath %>/logout" class="navbar-link">Logout</a>
        </div>
    </div>

    <!-- ALERTS -->
    <div class="container" style="padding-top: 40px; padding-bottom: 0;">
        <% if (error != null) { %>
            <div class="alert alert-error" style="margin-bottom: 24px;"><%= error %></div>
        <% } %>
        <% if (success != null) { %>
            <div class="alert alert-success" style="margin-bottom: 24px;"><%= success %></div>
        <% } %>
    </div>

    <!-- MAIN CONTENT -->
    <section class="container">
        <div class="dashboard-header">
            <h1>Admin Dashboard</h1>
            <a href="<%= contextPath %>/" class="btn btn-secondary">← Back to Home</a>
        </div>
        
        <!-- STATISTICS -->
        <% if (stats != null) { %>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number"><%= stats.getOrDefault("totalRooms", 0) %></div>
                    <div class="stat-label">Total Rooms</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= stats.getOrDefault("availableRooms", 0) %></div>
                    <div class="stat-label">Available Rooms</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= stats.getOrDefault("activeReservations", 0) %></div>
                    <div class="stat-label">Active Reservations</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= stats.getOrDefault("totalUsers", 0) %></div>
                    <div class="stat-label">Registered Users</div>
                </div>
            </div>
        <% } %>
        
        <!-- TABS -->
        <div class="tabs">
            <div class="tab active" onclick="switchTab('rooms')">Manage Rooms</div>
            <div class="tab" onclick="switchTab('reservations')">Reservations</div>
        </div>
        
        <!-- ROOMS TAB -->
        <div id="rooms" class="tab-content active">
            <h2>Manage Workspaces</h2>
            
            <!-- ADD ROOM FORM -->
            <div class="card" style="margin-bottom: 32px;">
                <h3>Add New Room</h3>
                <form method="POST" action="<%= contextPath %>/admin">
                    <input type="hidden" name="action" value="addRoom">
                    <div class="form-inline">
                        <div class="form-group">
                            <label for="roomName">Room Name</label>
                            <input type="text" id="roomName" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="capacity">Capacity</label>
                            <input type="number" id="capacity" name="capacity" min="1" required>
                        </div>
                        <div class="form-group">
                            <label for="location">Location</label>
                            <input type="text" id="location" name="location">
                        </div>
                        <button type="submit" class="btn btn-primary">Add Room</button>
                    </div>
                </form>
            </div>
            
            <!-- ROOMS TABLE -->
            <div class="card">
                <h3>All Rooms</h3>
                <% if (rooms != null && !rooms.isEmpty()) { %>
                    <table>
                        <thead>
                            <tr>
                                <th>Room Name</th>
                                <th>Capacity</th>
                                <th>Location</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Room room : rooms) { %>
                                <tr>
                                    <td><strong><%= room.getName() %></strong></td>
                                    <td><%= room.getCapacity() %> people</td>
                                    <td><%= room.getLocation() %></td>
                                    <td>
                                        <span style="padding: 4px 12px; border-radius: 20px; font-size: 13px; 
                                                    <%= room.getAvailable() == 1 ? "background: #d1fae5; color: #065f46;" : "background: #fee2e2; color: #991b1b;" %>">
                                            <%= room.getAvailable() == 1 ? "Available" : "Unavailable" %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <form method="POST" action="<%= contextPath %>/admin" style="display: inline;">
                                                <input type="hidden" name="action" value="toggleRoom">
                                                <input type="hidden" name="roomId" value="<%= room.getId() %>">
                                                <button type="submit" class="btn btn-secondary">
                                                    <%= room.getAvailable() == 1 ? "Disable" : "Enable" %>
                                                </button>
                                            </form>
                                            <form method="POST" action="<%= contextPath %>/admin" style="display: inline;">
                                                <input type="hidden" name="action" value="deleteRoom">
                                                <input type="hidden" name="roomId" value="<%= room.getId() %>">
                                                <button type="submit" class="btn btn-danger" onclick="return confirm('Delete this room?')">Delete</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <p style="text-align: center; padding: 32px; color: #86868b;">No rooms created yet</p>
                <% } %>
            </div>
        </div>
        
        <!-- RESERVATIONS TAB -->
        <div id="reservations" class="tab-content">
            <h2>All Reservations</h2>
            <% if (reservations != null && !reservations.isEmpty()) { %>
                <div class="card">
                    <table>
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Room ID</th>
                                <th>Start Time</th>
                                <th>End Time</th>
                                <th>Status</th>
                                <th>Duration</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Reservation res : reservations) { %>
                                <tr>
                                    <td><%= res.getUserId() %></td>
                                    <td><%= res.getRoomId() %></td>
                                    <td><%= res.getStartTime() %></td>
                                    <td><%= res.getEndTime() %></td>
                                    <td>
                                        <span style="padding: 4px 12px; border-radius: 20px; font-size: 13px;
                                                    <%= "ACTIVE".equals(res.getStatus()) ? "background: #dbeafe; color: #0c4a6e;" : "background: #f3f4f6; color: #6b7280;" %>">
                                            <%= res.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <% 
                                            long diffMinutes = (res.getEndTime().getTime() - res.getStartTime().getTime()) / (1000 * 60);
                                            long hours = diffMinutes / 60;
                                            long minutes = diffMinutes % 60;
                                        %>
                                        <%= hours > 0 ? hours + "h " : "" %><%= minutes %>m
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="card" style="text-align: center; padding: 60px;">
                    <p style="color: #86868b;">No reservations yet</p>
                </div>
            <% } %>
        </div>
    </section>

    <!-- FOOTER -->
    <footer>
        <div class="container">
            <div class="card-grid">
                <div>
                    <h3>Workspace Admin</h3>
                    <p>System management dashboard for workspace administrators.</p>
                </div>
            </div>
            <p style="margin-top: 40px; font-size: 13px;">
                © 2024 Workspace. All rights reserved.
            </p>
        </div>
    </footer>

    <script>
        function switchTab(tabName) {
            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });
            document.querySelectorAll('.tab').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Show selected tab
            document.getElementById(tabName).classList.add('active');
            event.target.classList.add('active');
        }
    </script>
</body>
</html>