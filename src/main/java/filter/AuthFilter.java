package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        boolean loggedIn = (session != null && session.getAttribute("user") != null);
        boolean isLoginPage = req.getRequestURI().endsWith("login.jsp")
                            || req.getRequestURI().endsWith("login");

        if (loggedIn || isLoginPage) {
            chain.doFilter(request, response);
        } else {
            resp.sendRedirect("login.jsp");
        }
    }
}
