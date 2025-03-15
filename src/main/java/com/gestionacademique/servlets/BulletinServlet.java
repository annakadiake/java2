package com.gestionacademique.servlets;

import java.io.IOException;
import java.io.OutputStream;
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
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

@WebServlet("/BulletinServlet")
public class BulletinServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        if (email == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=bulletin.pdf");

        try (Connection conn = DatabaseConnection.getConnection();
             OutputStream out = response.getOutputStream()) {

            Document document = new Document();
            PdfWriter.getInstance(document, out);
            document.open();

            // Titre du bulletin
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
            Paragraph title = new Paragraph("Bulletin de Notes", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            document.add(new Paragraph("\n"));

            // Récupérer les informations de l’étudiant
            String sql = "SELECT nom, prenom, filiere, niveau FROM etudiants WHERE email=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                document.add(new Paragraph("Nom : " + rs.getString("nom")));
                document.add(new Paragraph("Prénom : " + rs.getString("prenom")));
                document.add(new Paragraph("Filière : " + rs.getString("filiere")));
                document.add(new Paragraph("Niveau : " + rs.getString("niveau")));
                document.add(new Paragraph("\n"));
            }

            // Récupérer les notes
            sql = "SELECT m.nom, n.note FROM notes n INNER JOIN matieres m ON n.matiere_id = m.id WHERE n.etudiant_id = (SELECT id FROM etudiants WHERE email=?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();

            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(100);
            table.addCell(new PdfPCell(new Phrase("Matière")));
            table.addCell(new PdfPCell(new Phrase("Note")));

            float total = 0;
            int count = 0;

            while (rs.next()) {
                table.addCell(rs.getString("nom"));
                float note = rs.getFloat("note");
                table.addCell(String.valueOf(note));
                total += note;
                count++;
            }

            document.add(table);

            // Calcul de la moyenne générale
            float moyenne = count > 0 ? total / count : 0;
            document.add(new Paragraph("\nMoyenne Générale : " + String.format("%.2f", moyenne)));

            document.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
