// src/main/java/com/gestionacademique/rest/GestionAcademiqueApplication.java
package com.gestionacademique.rest;

import java.util.HashSet;
import java.util.Set;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

@ApplicationPath("/api")
public class GestionAcademiqueApplication extends Application {
    
    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> classes = new HashSet<>();
        
        // Enregistrez ici vos ressources REST
        classes.add(EtudiantResource.class);
        classes.add(EnseignantResource.class);
        classes.add(MatiereResource.class);
        classes.add(NoteResource.class);
        classes.add(AbsenceResource.class);
        classes.add(AuthResource.class);
        
        return classes;
    }
}