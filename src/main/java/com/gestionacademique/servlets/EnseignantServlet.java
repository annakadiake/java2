package com.gestionacademique.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.gestionacademique.utils.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EnseignantServlet")
public class EnseignantServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("ajouterNote".equals(action)) {
                int etudiantId = Integer.parseInt(request.getParameter("etudiant_id"));
                int matiereId = Integer.parseInt(request.getParameter("matiere_id"));
                float note = Float.parseFloat(request.getParameter("note"));

                String sql = "INSERT INTO notes (etudiant_id, matiere_id, note) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE note=?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, etudiantId);
                stmt.setInt(2, matiereId);
                stmt.setFloat(3, note);
                stmt.setFloat(4, note);
                stmt.executeUpdate();
            }

            if ("ajouterAbsence".equals(action)) {
                int etudiantId = Integer.parseInt(request.getParameter("etudiant_id"));
                int matiereId = Integer.parseInt(request.getParameter("matiere_id"));
                String dateAbsence = request.getParameter("date_absence");
                String justification = request.getParameter("justification");

                String sql = "INSERT INTO absences (etudiant_id, matiere_id, date_absence, justification) VALUES (?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, etudiantId);
                stmt.setInt(2, matiereId);
                stmt.setString(3, dateAbsence);
                stmt.setString(4, justification);
                stmt.executeUpdate();
            }

            response.sendRedirect("enseignant_dashboard.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
