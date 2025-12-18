<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.Room, model.User" %>
<%
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    User user = (User) userObj;
    String contextPath = request.getContextPath();
    
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Rooms - Workspace</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <style>
        .booking-header {
            background: linear-gradient(135deg, #ffffff 0%, #f5f5f7 100%);
            padding: 60px 40px;
            text-align: center;
        }
        
        .booking-header h1 {
            font-size: 48px;
            margin-bottom: 12px;
        }
        
        .booking-header p {
            font-size: 18px;
            color: #86868b;
        }
        
        .rooms-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
            margin-bottom: 60px;
        }
        
        .room-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid #e5e5e7;
            transition: all 0.3s ease;
        }
        
        .room-card:hover {
            border-color: #d2d2d7;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            transform: translateY(-4px);
        }
        
        .room-card-header {
            padding: 24px;
            background: linear-gradient(135deg, #0071e3 0%, #0077ed 100%);
            color: white;
        }
        
        .room-card-header h3 {
            margin: 0 0 8px 0;
            color: white;
        }
        
        .room-meta {
            display: flex;
            gap: 16px;
            margin-top: 12px;
            font-size: 14px;
        }
        
        .room-meta span {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        
        .room-card-body {
            padding: 24px;
        }
        
        .room-card-body p {
            color: #86868b;
            margin-bottom: 16px;
            font-size: 15px;
        }
        
        .booking-form {
            display: grid;
            gap: 12px;
            margin-bottom: 16px;
        }
        
        .booking-form input {
            padding: 10px 12px;
            font-size: 13px;
        }
        
        .booking-form label {
            font-size: 13px;
            margin-bottom: 4px;
        }
        
        .btn-book {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            margin-top: 8px;
        }
        
        .modal {
            display: none;
            position: fixed;
            z-index: 200;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            animation: fadeIn 0.3s ease;
        }
        
        .modal.show {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        .modal-content {
            background: white;
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: slideUp 0.3s ease;
        }
        
        @keyframes slideUp {
            from {
                transform: translateY(20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        .modal-close {
            float: right;
            font-size: 24px;
            cursor: pointer;
            color: #86868b;
            border: none;
            background: none;
            padding: 0;
            width: 24px;
            height: 24px;
        }
        
        .modal-close:hover {
            color: #000;
        }
        
        .modal h2 {
            text-align: left;
            margin-top: 0;
            margin-bottom: 24px;
            font-size: 28px;
        }
        
        .modal .form-group {
            margin-bottom: 16px;
        }
        
        .modal .btn-primary {
            width: 100%;
            margin-top: 16px;
        }
    </style>
</head>
<body>
    <!-- NAVBAR -->
    <div class="navbar">
        <strong>Workspace</strong>
        <div>
            <a href="<%= contextPath %>/dashboard.jsp">Dashboard</a>
            <a href="<%= contextPath %>/rooms">Rooms</a>
            <a href="<%= contextPath %>/logout" class="navbar-link">Logout</a>
        </div>
    </div>

    <!-- HEADER -->
    <div class="booking-header">
        <h1>Available Rooms</h1>
        <p>Choose your perfect workspace for focused work</p>
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

    <!-- ROOMS SECTION -->
    <section class="container">
        <% if (rooms != null && !rooms.isEmpty()) { %>
            <div class="rooms-grid">
                <% for (Room room : rooms) { %>
                    <div class="room-card">
                        <div class="room-card-header">
                            <h3><%= room.getName() %></h3>
                            <div class="room-meta">
                                <span>👥 <%= room.getCapacity() %> people</span>
                                <span>📍 <%= room.getLocation() %></span>
                            </div>
                        </div>
                        <div class="room-card-body">
                            <p>Premium workspace designed for focused, distraction-free work sessions.</p>
                            <button class="btn btn-primary btn-book" onclick="openBookingModal(<%= room.getId() %>, '<%= room.getName() %>')">
                                Book Now
                            </button>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="card" style="text-align: center; padding: 60px;">
                <h3>No rooms available</h3>
                <p style="color: #86868b;">Please check back later for available workspaces.</p>
            </div>
        <% } %>
    </section>

    <!-- BOOKING MODAL -->
    <div id="bookingModal" class="modal">
        <div class="modal-content">
            <button class="modal-close" onclick="closeBookingModal()">×</button>
            <h2 id="roomTitle">Book Room</h2>
            
            <form method="POST" action="<%= contextPath %>/reserve">
                <input type="hidden" id="roomId" name="roomId">
                
                <div class="form-group">
                    <label for="start">Start Time</label>
                    <input type="datetime-local" id="startInput" name="startDisplay" required>
                    <input type="hidden" id="start" name="start">
                </div>
                
                <div class="form-group">
                    <label for="end">End Time</label>
                    <input type="datetime-local" id="endInput" name="endDisplay" required>
                    <input type="hidden" id="end" name="end">
                </div>
                
                <p style="font-size: 13px; color: #86868b; margin: 16px 0;">
                    💡 Minimum booking duration is 30 minutes. Select your preferred time slot above.
                </p>
                
                <button type="submit" class="btn btn-primary">Confirm Reservation</button>
                <button type="button" class="btn btn-secondary" onclick="closeBookingModal()" style="width: 100%; margin-top: 8px;">Cancel</button>
            </form>
        </div>
    </div>

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

    <script>
        // Convert datetime-local format to SQL Timestamp format
        function convertToSQLFormat(datetimeLocal) {
            if (!datetimeLocal) return '';
            // Input: "2025-12-20T14:30"
            // Output: "2025-12-20 14:30:00"
            return datetimeLocal.replace('T', ' ') + ':00';
        }
        
        function openBookingModal(roomId, roomName) {
            document.getElementById('roomId').value = roomId;
            document.getElementById('roomTitle').textContent = 'Book ' + roomName;
            document.getElementById('bookingModal').classList.add('show');
            
            // Set minimum start time to now
            const now = new Date();
            now.setMinutes(now.getMinutes() + 15);
            const minStartStr = now.toISOString().slice(0, 16);
            document.getElementById('startInput').min = minStartStr;
            document.getElementById('startInput').value = minStartStr;
            document.getElementById('start').value = convertToSQLFormat(minStartStr);
            
            // Set end time to 1 hour later
            const endTime = new Date(now.getTime() + 60 * 60 * 1000);
            const endStr = endTime.toISOString().slice(0, 16);
            document.getElementById('endInput').value = endStr;
            document.getElementById('end').value = convertToSQLFormat(endStr);
        }
        
        function closeBookingModal() {
            document.getElementById('bookingModal').classList.remove('show');
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('bookingModal');
            if (event.target === modal) {
                modal.classList.remove('show');
            }
        }
        
        // Validate end time is after start time and update hidden fields
        document.addEventListener('change', function(e) {
            if (e.target.id === 'startInput') {
                const startTime = new Date(e.target.value);
                const minEndTime = new Date(startTime.getTime() + 30 * 60 * 1000);
                const minEndStr = minEndTime.toISOString().slice(0, 16);
                
                document.getElementById('endInput').min = minEndStr;
                
                if (new Date(document.getElementById('endInput').value) < minEndTime) {
                    document.getElementById('endInput').value = minEndStr;
                    document.getElementById('end').value = convertToSQLFormat(minEndStr);
                }
                
                // Update hidden start field
                document.getElementById('start').value = convertToSQLFormat(e.target.value);
            }
            
            if (e.target.id === 'endInput') {
                // Update hidden end field
                document.getElementById('end').value = convertToSQLFormat(e.target.value);
            }
        });
    </script>
</body>
</html>