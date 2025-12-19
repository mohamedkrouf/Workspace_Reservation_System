package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Filter initialization - can be empty
        System.out.println("AuthFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        
        // Get existing session only (don't create new one)
        HttpSession session = req.getSession(false);
        
        // Check if user is logged in
        boolean loggedIn = (session != null && session.getAttribute("user") != null);
        
        // Get request URI to check if it's a login/register page
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        
        // Allow access to login, register, and public pages
        boolean isPublicPage = uri.endsWith("login.jsp") 
                            || uri.endsWith("register.jsp")
                            || uri.endsWith("/login")
                            || uri.endsWith("/register")
                            || uri.equals(contextPath + "/")
                            || uri.equals(contextPath);
        
        if (loggedIn || isPublicPage) {
            // User is logged in or accessing public page - allow access
            chain.doFilter(request, response);
        } else {
            // User not logged in - redirect to login page
            resp.sendRedirect(contextPath + "/login.jsp");
        }
    }
    
    @Override
    public void destroy() {
        // Filter cleanup - can be empty
        System.out.println("AuthFilter destroyed");
    }
}
