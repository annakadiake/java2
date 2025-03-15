package com.gestionacademique.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.gestionacademique.model.Note;
import com.gestionacademique.utils.DatabaseConnection;

public class NoteDAO {
    
    // Insérer une nouvelle note
    public Note inserer(Note note) throws SQLException {
        String sql = "INSERT INTO notes (etudiant_id, matiere_id, valeur) VALUES (?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setLong(1, note.getEtudiantId());
            pstmt.setLong(2, note.getMatiereId());
            pstmt.setFloat(3, note.getValeur());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    note.setId(rs.getLong(1));
                }
                rs.close();
            }
        }
        
        return note;
    }
    
    // Mettre à jour une note
    public void mettre_a_jour(Note note) throws SQLException {
        String sql = "UPDATE notes SET etudiant_id = ?, matiere_id = ?, valeur = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, note.getEtudiantId());
            pstmt.setLong(2, note.getMatiereId());
            pstmt.setFloat(3, note.getValeur());
            pstmt.setLong(4, note.getId());
            
            pstmt.executeUpdate();
        }
    }
    
    // Supprimer une note
    public void supprimer(Long id) throws SQLException {
        String sql = "DELETE FROM notes WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            pstmt.executeUpdate();
        }
    }
    
    // Trouver une note par ID
    public Note trouverParId(Long id) throws SQLException {
        String sql = "SELECT * FROM notes WHERE id = ?";
        Note note = null;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                note = extractNoteFromResultSet(rs);
            }
        }
        
        return note;
    }
    
    // Trouver les notes par étudiant
    public List<Note> trouverParEtudiant(Long etudiantId) throws SQLException {
        String sql = "SELECT * FROM notes WHERE etudiant_id = ?";
        List<Note> notes = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, etudiantId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                notes.add(extractNoteFromResultSet(rs));
            }
        }
        
        return notes;
    }
    
    // Trouver les notes par matière
    public List<Note> trouverParMatiere(Long matiereId) throws SQLException {
        String sql = "SELECT * FROM notes WHERE matiere_id = ?";
        List<Note> notes = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, matiereId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                notes.add(extractNoteFromResultSet(rs));
            }
        }
        
        return notes;
    }
    
    // Calculer la moyenne pour un étudiant
    public float calculerMoyenne(Long etudiantId) throws SQLException {
        String sql = "SELECT AVG(n.valeur) as moyenne FROM notes n " +
                     "JOIN matieres m ON n.matiere_id = m.id " +
                     "WHERE n.etudiant_id = ?";
        float moyenne = 0;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, etudiantId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                moyenne = rs.getFloat("moyenne");
            }
        }
        
        return moyenne;
    }
    
    // Calculer la moyenne pondérée pour un étudiant (avec coefficients)
    public float calculerMoyennePonderee(Long etudiantId) throws SQLException {
        String sql = "SELECT SUM(n.valeur * m.coefficient) / SUM(m.coefficient) as moyenne_ponderee " +
                     "FROM notes n " +
                     "JOIN matieres m ON n.matiere_id = m.id " +
                     "WHERE n.etudiant_id = ?";
        float moyennePonderee = 0;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, etudiantId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                moyennePonderee = rs.getFloat("moyenne_ponderee");
            }
        }
        
        return moyennePonderee;
    }
    
    // Méthode utilitaire pour extraire une note d'un ResultSet
    private Note extractNoteFromResultSet(ResultSet rs) throws SQLException {
        Note note = new Note();
        note.setId(rs.getLong("id"));
        note.setEtudiantId(rs.getLong("etudiant_id"));
        note.setMatiereId(rs.getLong("matiere_id"));
        note.setValeur(rs.getFloat("valeur"));
        return note;
    }
   
}