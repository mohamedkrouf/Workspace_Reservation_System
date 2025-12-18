package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import dao.ReservationDAO;
import model.User;

@WebServlet("/reserve")
public class ReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User u = (User) req.getSession().getAttribute("user");
            if (u == null) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            String roomIdStr = req.getParameter("roomId");
            String startStr = req.getParameter("start");
            String endStr = req.getParameter("end");

            // Validate inputs
            if (roomIdStr == null || startStr == null || endStr == null) {
                req.setAttribute("error", "Missing required fields");
                req.getRequestDispatcher("rooms.jsp").forward(req, resp);
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);
            Timestamp start = Timestamp.valueOf(startStr);
            Timestamp end = Timestamp.valueOf(endStr);

            // Validate time logic
            if (!start.before(end)) {
                req.setAttribute("error", "End time must be after start time");
                req.getRequestDispatcher("rooms.jsp").forward(req, resp);
                return;
            }

            // Validate minimum duration (at least 30 minutes)
            long diffMinutes = (end.getTime() - start.getTime()) / (1000 * 60);
            if (diffMinutes < 30) {
                req.setAttribute("error", "Reservation must be at least 30 minutes");
                req.getRequestDispatcher("rooms.jsp").forward(req, resp);
                return;
            }

            // Check room availability
            if (!ReservationDAO.isRoomAvailable(roomId, start, end)) {
                req.setAttribute("error", "Room is not available for this time slot");
                req.getRequestDispatcher("rooms.jsp").forward(req, resp);
                return;
            }

            // Check user availability
            if (!ReservationDAO.isUserAvailable(u.getId(), start, end)) {
                req.setAttribute("error", "You already have a reservation during this time");
                req.getRequestDispatcher("rooms.jsp").forward(req, resp);
                return;
            }

            // Create reservation
            boolean created = ReservationDAO.createReservation(u.getId(), roomId, start, end);
            if (created) {
                req.setAttribute("success", "Reservation created successfully!");
            } else {
                req.setAttribute("error", "Failed to create reservation");
            }

            req.getRequestDispatcher("rooms.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid room ID");
            try {
                req.getRequestDispatcher("rooms.jsp").forward(req, resp);
            } catch (ServletException ex) {
                throw new ServletException(ex);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}