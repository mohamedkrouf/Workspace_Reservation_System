package controller;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;



@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // Validate inputs
        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "Name is required");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Email is required");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        if (password == null || password.trim().isEmpty() || password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        try {
            boolean ok = UserDAO.register(name.trim(), email.trim(), password);

            if (ok) {
                req.setAttribute("success", "Registration successful! Please login.");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Email already exists");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}