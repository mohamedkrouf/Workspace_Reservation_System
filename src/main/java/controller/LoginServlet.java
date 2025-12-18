package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.security.MessageDigest;
import java.util.Base64;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Hash password using SHA-256
    private static String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes());
        return Base64.getEncoder().encodeToString(hash);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        // DEBUG: Print inputs
        System.out.println("=== LOGIN DEBUG ===");
        System.out.println("Email received: " + email);
        System.out.println("Password received: " + password);

        // Validate inputs
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            System.out.println("ERROR: Empty email or password");
            req.setAttribute("error", "Email and password are required");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        try {
            // Trim and prepare input
            email = email.trim();
            String hashedPassword = hashPassword(password);
            
            System.out.println("Hashed password: " + hashedPassword);
            System.out.println("Attempting login for: " + email);

            // Call UserDAO login
            User user = UserDAO.login(email, password);

            if (user != null) {
                System.out.println("SUCCESS: User found - ID: " + user.getId() + ", Role: " + user.getRole());
                
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("role", user.getRole());

                // Redirect based on role
                if ("ADMIN".equals(user.getRole())) {
                    System.out.println("Redirecting to admin dashboard");
                    resp.sendRedirect(req.getContextPath() + "/admin");
                } else {
                    System.out.println("Redirecting to user dashboard");
                    resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
                }
                return;
            } else {
                System.out.println("FAILED: User not found or password mismatch");
                req.setAttribute("error", "Invalid email or password");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            System.out.println("EXCEPTION: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Login error: " + e.getMessage());
            try {
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            } catch (Exception ex) {
                throw new ServletException(ex);
            }
        }
    }
}