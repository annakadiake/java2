package com.gestionacademique.model;

public class Matiere {
    private Long id;
    private String nom;
    private String code;
    private int coefficient;
    private Long enseignantId;
    
    // Constructeurs
    public Matiere() {}
    
    public Matiere(Long id, String nom, String code, int coefficient, Long enseignantId) {
        this.id = id;
        this.nom = nom;
        this.code = code;
        this.coefficient = coefficient;
        this.enseignantId = enseignantId;
    }
    
    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getCoefficient() {
        return coefficient;
    }

    public void setCoefficient(int coefficient) {
        this.coefficient = coefficient;
    }

    public Long getEnseignantId() {
        return enseignantId;
    }

    public void setEnseignantId(Long enseignantId) {
        this.enseignantId = enseignantId;
    }
}