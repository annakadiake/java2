package com.gestionacademique.model;

public class Note {
    private Long id;
    private Long etudiantId;
    private Long matiereId;
    private Float valeur;
    
    // Constructeurs
    public Note() {}
    
    public Note(Long id, Long etudiantId, Long matiereId, Float valeur) {
        this.id = id;
        this.etudiantId = etudiantId;
        this.matiereId = matiereId;
        this.valeur = valeur;
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

    public Float getValeur() {
        return valeur;
    }

    public void setValeur(Float valeur) {
        this.valeur = valeur;
    }
}