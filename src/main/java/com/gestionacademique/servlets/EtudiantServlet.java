package com.gestionacademique.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.gestionacademique.utils.DatabaseConnection;

@WebServlet("/EtudiantServlet")
public class EtudiantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        if (email == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Récupérer les informations de l'étudiant
            String sql = "SELECT * FROM etudiants WHERE email=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("nom", rs.getString("nom"));
                request.setAttribute("prenom", rs.getString("prenom"));
                request.setAttribute("email", rs.getString("email"));
                request.setAttribute("filiere", rs.getString("filiere"));
                request.setAttribute("niveau", rs.getString("niveau"));
            }

            // Récupérer les notes et la moyenne
            sql = "SELECT m.nom, n.note FROM notes n INNER JOIN matieres m ON n.matiere_id = m.id WHERE n.etudiant_id = (SELECT id FROM etudiants WHERE email=?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            request.setAttribute("notes", rs);

            // Récupérer les absences
            sql = "SELECT m.nom, a.date_absence, a.justification FROM absences a INNER JOIN matieres m ON a.matiere_id = m.id WHERE a.etudiant_id = (SELECT id FROM etudiants WHERE email=?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            request.setAttribute("absences", rs);

            request.getRequestDispatcher("etudiant_dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
