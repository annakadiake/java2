package com.gestionacademique.model;

import java.util.Date;

public class Absence {
    private Long id;
    private Long etudiantId;
    private Long matiereId;
    private Date dateAbsence;
    private String justification;
    
    // Constructeurs
    public Absence() {}
    
    public Absence(Long id, Long etudiantId, Long matiereId, Date dateAbsence, String justification) {
        this.id = id;
        this.etudiantId = etudiantId;
        this.matiereId = matiereId;
        this.dateAbsence = dateAbsence;
        this.justification = justification;
    }
    
    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getEtudiantId() {
        return etudiantId;
    }

    public void setEtudiantId(Long etudiantId) {
        this.etudiantId = etudiantId;
    }

    public Long getMatiereId() {
        return matiereId;
    }

    public void setMatiereId(Long matiereId) {
        this.matiereId = matiereId;
    }

    public Date getDateAbsence() {
        return dateAbsence;
    }

    public void setDateAbsence(Date dateAbsence) {
        this.dateAbsence = dateAbsence;
    }

    public String getJustification() {
        return justification;
    }

    public void setJustification(String justification) {
        this.justification = justification;
    }
}