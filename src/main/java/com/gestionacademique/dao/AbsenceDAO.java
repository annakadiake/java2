package com.gestionacademique.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.gestionacademique.model.Absence;
import com.gestionacademique.utils.DatabaseConnection;

public class AbsenceDAO {
    
    // Insérer une nouvelle absence
    public Absence inserer(Absence absence) throws SQLException {
        String sql = "INSERT INTO absences (etudiant_id, matiere_id, date_absence, justification) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setLong(1, absence.getEtudiantId());
            pstmt.setLong(2, absence.getMatiereId());
            pstmt.setDate(3, new java.sql.Date(absence.getDateAbsence().getTime()));
            pstmt.setString(4, absence.getJustification());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    absence.setId(rs.getLong(1));
                }
                rs.close();
            }
        }
        
        return absence;
    }
    
    // Mettre à jour une absence
    public void mettre_a_jour(Absence absence) throws SQLException {
        String sql = "UPDATE absences SET etudiant_id = ?, matiere_id = ?, date_absence = ?, justification = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, absence.getEtudiantId());
            pstmt.setLong(2, absence.getMatiereId());
            pstmt.setDate(3, new java.sql.Date(absence.getDateAbsence().getTime()));
            pstmt.setString(4, absence.getJustification());
            pstmt.setLong(5, absence.getId());
            
            pstmt.executeUpdate();
        }
    }
    
    // Supprimer une absence
    public void supprimer(Long id) throws SQLException {
        String sql = "DELETE FROM absences WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            pstmt.executeUpdate();
        }
    }
    
    // Trouver une absence par ID
    public Absence trouverParId(Long id) throws SQLException {
        String sql = "SELECT * FROM absences WHERE id = ?";
        Absence absence = null;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                absence = extractAbsenceFromResultSet(rs);
            }
        }
        
        return absence;
    }
    
    // Trouver les absences par étudiant
    public List<Absence> trouverParEtudiant(Long etudiantId) throws SQLException {
        String sql = "SELECT * FROM absences WHERE etudiant_id = ?";
        List<Absence> absences = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, etudiantId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                absences.add(extractAbsenceFromResultSet(rs));
            }
        }
        
        return absences;
    }
    
    // Trouver les absences par matière
    public List<Absence> trouverParMatiere(Long matiereId) throws SQLException {
        String sql = "SELECT * FROM absences WHERE matiere_id = ?";
        List<Absence> absences = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, matiereId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                absences.add(extractAbsenceFromResultSet(rs));
            }
        }
        
        return absences;
    }
    
    // Compter les absences par étudiant
    public int compterAbsencesParEtudiant(Long etudiantId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM absences WHERE etudiant_id = ?";
        int total = 0;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, etudiantId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt("total");
            }
        }
        
        return total;
    }
    
    // Méthode utilitaire pour extraire une absence d'un ResultSet
    private Absence extractAbsenceFromResultSet(ResultSet rs) throws SQLException {
        Absence absence = new Absence();
        absence.setId(rs.getLong("id"));
        absence.setEtudiantId(rs.getLong("etudiant_id"));
        absence.setMatiereId(rs.getLong("matiere_id"));
        absence.setDateAbsence(rs.getDate("date_absence"));
        absence.setJustification(rs.getString("justification"));
        return absence;
    }
}
