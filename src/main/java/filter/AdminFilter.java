package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Filter initialization - can be empty
        System.out.println("AdminFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        
        // Get existing session (don't create new one)
        HttpSession session = req.getSession(false);
        
        // Check if user is logged in and has ADMIN role
        if (session != null && "ADMIN".equals(session.getAttribute("role"))) {
            // User is admin - allow access
            chain.doFilter(request, response);
        } else {
            // Not admin - redirect to dashboard or login
            String contextPath = req.getContextPath();
            if (session != null && session.getAttribute("user") != null) {
                // User is logged in but not admin - redirect to user dashboard
                resp.sendRedirect(contextPath + "/dashboard.jsp");
            } else {
                // User not logged in - redirect to login
                resp.sendRedirect(contextPath + "/login.jsp");
            }
        }
    }
    
    @Override
    public void destroy() {
        // Filter cleanup - can be empty
        System.out.println("AdminFilter destroyed");
    }
}
