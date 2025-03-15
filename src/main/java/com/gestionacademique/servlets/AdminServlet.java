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
import com.gestionacademique.utils.DatabaseConnection;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Compter les étudiants
            String sql = "SELECT COUNT(*) AS total FROM etudiants";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                request.setAttribute("totalEtudiants", rs.getInt("total"));
            }

            // Compter les enseignants
            sql = "SELECT COUNT(*) AS total FROM enseignants";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                request.setAttribute("totalEnseignants", rs.getInt("total"));
            }

            // Compter les matières
            sql = "SELECT COUNT(*) AS total FROM matieres";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                request.setAttribute("totalMatieres", rs.getInt("total"));
            }

            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("ajouterEtudiant".equals(action)) {
                String nom = request.getParameter("nom");
                String prenom = request.getParameter("prenom");
                String email = request.getParameter("email");
                String filiere = request.getParameter("filiere");
                String niveau = request.getParameter("niveau");

                String sql = "INSERT INTO etudiants (nom, prenom, email, filiere, niveau) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, nom);
                stmt.setString(2, prenom);
                stmt.setString(3, email);
                stmt.setString(4, filiere);
                stmt.setString(5, niveau);
                stmt.executeUpdate();
            }

            if ("ajouterEnseignant".equals(action)) {
                String nom = request.getParameter("nom");
                String prenom = request.getParameter("prenom");
                String email = request.getParameter("email");
                String specialite = request.getParameter("specialite");

                String sql = "INSERT INTO enseignants (nom, prenom, email, specialite) VALUES (?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, nom);
                stmt.setString(2, prenom);
                stmt.setString(3, email);
                stmt.setString(4, specialite);
                stmt.executeUpdate();
            }

            if ("ajouterMatiere".equals(action)) {
                String nom = request.getParameter("nom");
                int coefficient = Integer.parseInt(request.getParameter("coefficient"));

                String sql = "INSERT INTO matieres (nom, coefficient) VALUES (?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, nom);
                stmt.setInt(2, coefficient);
                stmt.executeUpdate();
            }

            response.sendRedirect("admin_dashboard.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
