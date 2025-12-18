package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.ReservationDAO;
import model.User;

@WebServlet("/cancel-reservation")
public class CancelReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User u = (User) req.getSession().getAttribute("user");
            if (u == null) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            String reservationIdStr = req.getParameter("reservationId");
            if (reservationIdStr == null || reservationIdStr.trim().isEmpty()) {
                req.setAttribute("error", "Invalid reservation ID");
                req.getRequestDispatcher("my-reservations.jsp").forward(req, resp);
                return;
            }

            try {
                int reservationId = Integer.parseInt(reservationIdStr);
                boolean cancelled = ReservationDAO.cancelReservation(reservationId, u.getId());
                
                if (cancelled) {
                    req.setAttribute("success", "Reservation cancelled successfully");
                } else {
                    req.setAttribute("error", "Failed to cancel reservation or you don't have permission");
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid reservation ID format");
            }

            req.getRequestDispatcher("my-reservations.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}