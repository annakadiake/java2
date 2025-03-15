package com.gestionacademique.filters;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String path = httpRequest.getRequestURI();
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        boolean isLoggedIn = (role != null);
        boolean isPublicPage = path.contains("login.jsp") || path.contains("LoginServlet");

        if (!isLoggedIn && !isPublicPage) {
            httpResponse.sendRedirect("login.jsp");
            return;
        }

        if (role != null) {
            if (role.equals("etudiant") && path.contains("admin_dashboard.jsp")) {
                httpResponse.sendRedirect("etudiant_dashboard.jsp");
                return;
            }
            if (role.equals("enseignant") && path.contains("admin_dashboard.jsp")) {
                httpResponse.sendRedirect("enseignant_dashboard.jsp");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    public void init(FilterConfig fConfig) throws ServletException {}
    public void destroy() {}
}
