package com.gestionacademique.servlets;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.gestionacademique.dao.UtilisateurDAO;
import com.gestionacademique.dao.EtudiantDAO;
import com.gestionacademique.dao.EnseignantDAO;
import com.gestionacademique.model.Utilisateur;
import com.gestionacademique.model.Etudiant;
import com.gestionacademique.model.Enseignant;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UtilisateurDAO utilisateurDAO = new UtilisateurDAO();
    private EtudiantDAO etudiantDAO = new EtudiantDAO();
    private EnseignantDAO enseignantDAO = new EnseignantDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Utilisateur utilisateur = utilisateurDAO.authentifier(email, password);

            if (utilisateur != null) {
                HttpSession session = request.getSession();
                session.setAttribute("email", email);
                session.setAttribute("role", utilisateur.getRole());
                session.setAttribute("utilisateurId", utilisateur.getId());

                switch (utilisateur.getRole()) {
                    case "etudiant":
                        // Récupérer les informations de l'étudiant
                        Etudiant etudiant = etudiantDAO.trouverParEmail(email);
                        session.setAttribute("etudiantId", etudiant.getId());
                        response.sendRedirect("EtudiantServlet");
                        break;
                    case "enseignant":
                        // Récupérer les informations de l'enseignant
                        Enseignant enseignant = enseignantDAO.trouverParEmail(email);
                        session.setAttribute("enseignantId", enseignant.getId());
                        response.sendRedirect("EnseignantServlet");
                        break;
                    case "admin":
                        response.sendRedirect("AdminServlet");
                        break;
                    default:
                        response.sendRedirect("login.jsp?error=role_inconnu");
                        break;
                }
            } else {
                response.sendRedirect("login.jsp?error=invalid");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=server_error");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Rediriger vers la page de connexion
        response.sendRedirect("login.jsp");
    }
}