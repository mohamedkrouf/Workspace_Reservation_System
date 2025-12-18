package controller;

import dao.AdminDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setAttribute("rooms", AdminDAO.getAllRooms());
            req.setAttribute("reservations", AdminDAO.getAllReservations());
            req.setAttribute("stats", AdminDAO.getStatistics());
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String action = req.getParameter("action");

            if ("addRoom".equals(action)) {
                String name = req.getParameter("name");
                String capacityStr = req.getParameter("capacity");
                String location = req.getParameter("location");

                if (name == null || name.trim().isEmpty() || capacityStr == null) {
                    req.setAttribute("error", "Name and capacity are required");
                } else {
                    try {
                        int capacity = Integer.parseInt(capacityStr);
                        if (capacity <= 0) {
                            req.setAttribute("error", "Capacity must be greater than 0");
                        } else if (AdminDAO.addRoom(name, capacity, location)) {
                            req.setAttribute("success", "Room added successfully");
                        } else {
                            req.setAttribute("error", "Failed to add room");
                        }
                    } catch (NumberFormatException e) {
                        req.setAttribute("error", "Invalid capacity format");
                    }
                }
            }

            if ("toggleRoom".equals(action)) {
                String roomIdStr = req.getParameter("roomId");
                if (roomIdStr != null) {
                    int roomId = Integer.parseInt(roomIdStr);
                    if (AdminDAO.toggleRoom(roomId)) {
                        req.setAttribute("success", "Room status updated");
                    } else {
                        req.setAttribute("error", "Failed to update room");
                    }
                }
            }

            if ("deleteRoom".equals(action)) {
                String roomIdStr = req.getParameter("roomId");
                if (roomIdStr != null) {
                    int roomId = Integer.parseInt(roomIdStr);
                    if (AdminDAO.deleteRoom(roomId)) {
                        req.setAttribute("success", "Room deleted successfully");
                    } else {
                        req.setAttribute("error", "Failed to delete room");
                    }
                }
            }

            resp.sendRedirect(req.getContextPath() + "/admin");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}