<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.Reservation, model.User, model.Room, dao.ReservationDAO, dao.AdminDAO" %>
<%
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    User user = (User) userObj;
    String contextPath = request.getContextPath();
    
    List<Reservation> reservations = null;
    try {
        reservations = ReservationDAO.getUserReservations(user.getId());
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reservations - Workspace</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <style>
        .reservations-header {
            padding: 60px 40px;
            background: linear-gradient(135deg, #ffffff 0%, #f5f5f7 100%);
        }
        
        .reservations-header h1 {
            font-size: 48px;
            margin-bottom: 8px;
        }
        
        .reservations-header p {
            font-size: 18px;
            color: #86868b;
        }
        
        .reservation-card {
            background: white;
            border-radius: 12px;
            border: 1px solid #e5e5e7;
            padding: 24px;
            margin-bottom: 16px;
            transition: all 0.3s ease;
        }
        
        .reservation-card:hover {
            border-color: #d2d2d7;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
        }
        
        .reservation-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 16px;
        }
        
        .reservation-header h3 {
            margin: 0;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
        }
        
        .status-active {
            background: #d1fae5;
            color: #065f46;
        }
        
        .status-cancelled {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .reservation-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 16px;
        }
        
        .detail-item {
            font-size: 14px;
        }
        
        .detail-label {
            color: #86868b;
            font-size: 13px;
            margin-bottom: 4px;
        }
        
        .detail-value {
            color: #1d1d1f;
            font-weight: 500;
        }
        
        .unavailable-notice {
            background: #fef2f2;
            border: 1px solid #fca5a5;
            color: #991b1b;
            padding: 12px;
            border-radius: 8px;
            font-size: 13px;
            margin-top: 12px;
        }
        
        .reservation-actions {
            display: flex;
            gap: 12px;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid #e5e5e7;
        }
        
        .empty-state {
            text-align: center;
            padding: 80px 40px;
        }
        
        .empty-state h3 {
            font-size: 24px;
            margin-bottom: 12px;
        }
        
        .empty-state p {
            color: #86868b;
            margin-bottom: 32px;
        }
        
        @media (max-width: 768px) {
            .reservations-header {
                padding: 40px 20px;
            }
            
            .reservations-header h1 {
                font-size: 32px;
            }
            
            .reservation-header {
                flex-direction: column;
                gap: 12px;
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
            <a href="<%= contextPath %>/logout" class="navbar-link">Logout</a>
        </div>
    </div>

    <!-- HEADER -->
    <div class="reservations-header">
        <h1>My Reservations</h1>
        <p>View and manage your workspace bookings</p>
    </div>

    <!-- ALERTS -->
    <div class="container" style="padding-top: 40px; padding-bottom: 0;">
        <% if (success != null) { %>
            <div class="alert alert-success" style="margin-bottom: 24px;"><%= success %></div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert alert-error" style="margin-bottom: 24px;"><%= error %></div>
        <% } %>
    </div>

    <!-- RESERVATIONS LIST -->
    <section class="container">
        <% if (reservations != null && !reservations.isEmpty()) { %>
            <div>
                <% for (Reservation res : reservations) { 
                    Room room = null;
                    try {
                        room = AdminDAO.getRoomById(res.getRoomId());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    
                    boolean isActive = "ACTIVE".equals(res.getStatus());
                    long diffMinutes = (res.getEndTime().getTime() - res.getStartTime().getTime()) / (1000 * 60);
                    long hours = diffMinutes / 60;
                    long minutes = diffMinutes % 60;
                    boolean isPast = res.getEndTime().getTime() < System.currentTimeMillis();
                %>
                    <div class="reservation-card">
                        <div class="reservation-header">
                            <div>
                                <h3><%= room != null ? room.getName() : "Room #" + res.getRoomId() %></h3>
                                <p style="color: #86868b; margin: 4px 0 0 0;">
                                    <%= room != null ? room.getLocation() : "Unknown Location" %>
                                </p>
                            </div>
                            <span class="status-badge <%= isActive ? "status-active" : "status-cancelled" %>">
                                <%= isActive ? "Active" : "Cancelled" %>
                            </span>
                        </div>
                        
                        <div class="reservation-details">
                            <div class="detail-item">
                                <div class="detail-label">📅 Start Date & Time</div>
                                <div class="detail-value"><%= res.getStartTime() %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">⏱️ End Date & Time</div>
                                <div class="detail-value"><%= res.getEndTime() %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">⏰ Duration</div>
                                <div class="detail-value"><%= hours > 0 ? hours + "h " : "" %><%= minutes %>m</div>
                            </div>
                        </div>
                        
                        <% if (room == null) { %>
                            <div class="unavailable-notice">
                                ⚠️ This room is no longer available. The admin has removed it.
                            </div>
                        <% } else if (room.getAvailable() == 0) { %>
                            <div class="unavailable-notice">
                                ⚠️ This room is currently disabled by the admin.
                            </div>
                        <% } %>
                        
                        <div class="reservation-actions">
                            <% if (isActive && !isPast) { %>
                                <form method="POST" action="<%= contextPath %>/cancel-reservation" style="display: inline;">
                                    <input type="hidden" name="reservationId" value="<%= res.getId() %>">
                                    <button type="submit" class="btn btn-danger btn-small" onclick="return confirm('Are you sure you want to cancel this reservation?')">
                                        Cancel Reservation
                                    </button>
                                </form>
                            <% } else if (isPast) { %>
                                <span style="color: #86868b; font-size: 14px; padding: 8px 0;">
                                    ✓ This reservation has ended
                                </span>
                            <% } else { %>
                                <span style="color: #86868b; font-size: 14px; padding: 8px 0;">
                                    This reservation has been cancelled
                                </span>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <h3>No reservations yet</h3>
                <p>You haven't booked any workspace sessions yet.</p>
                <a href="<%= contextPath %>/rooms" class="btn btn-primary" style="padding: 12px 24px; font-size: 16px;">
                    Book Your First Room
                </a>
            </div>
        <% } %>
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