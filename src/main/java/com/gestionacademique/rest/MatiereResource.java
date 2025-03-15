package com.gestionacademique.rest;

import java.sql.SQLException;
import java.util.List;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import com.gestionacademique.dao.MatiereDAO;
import com.gestionacademique.model.Matiere;

@Path("/matieres")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class MatiereResource {
    
    private MatiereDAO matiereDAO = new MatiereDAO();
    
    @GET
    public Response getAllMatieres() {
        try {
            List<Matiere> matieres = matiereDAO.trouverTous();
            return Response.ok(matieres).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération des matières: " + e.getMessage())
                          .build();
        }
    }
    
    @GET
    @Path("/{id}")
    public Response getMatiereById(@PathParam("id") Long id) {
        try {
            Matiere matiere = matiereDAO.trouverParId(id);
            if (matiere != null) {
                return Response.ok(matiere).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Matière non trouvée avec l'ID: " + id)
                              .build();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération de la matière: " + e.getMessage())
                          .build();
        }
    }
    
    @GET
    @Path("/enseignant/{enseignantId}")
    public Response getMatieresByEnseignant(@PathParam("enseignantId") Long enseignantId) {
        try {
            List<Matiere> matieres = matiereDAO.trouverParEnseignant(enseignantId);
            return Response.ok(matieres).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération des matières par enseignant: " + e.getMessage())
                          .build();
        }
    }
    
    @GET
    @Path("/etudiant/{etudiantId}")
    public Response getMatieresByEtudiant(@PathParam("etudiantId") Long etudiantId) {
        try {
            List<Matiere> matieres = matiereDAO.trouverParEtudiant(etudiantId);
            return Response.ok(matieres).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération des matières par étudiant: " + e.getMessage())
                          .build();
        }
    }
    
    @POST
    public Response createMatiere(Matiere matiere) {
        try {
            Matiere newMatiere = matiereDAO.inserer(matiere);
            return Response.status(Response.Status.CREATED)
                          .entity(newMatiere)
                          .build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la création de la matière: " + e.getMessage())
                          .build();
        }
    }
    
    @PUT
    @Path("/{id}")
    public Response updateMatiere(@PathParam("id") Long id, Matiere matiere) {
        try {
            Matiere existingMatiere = matiereDAO.trouverParId(id);
            if (existingMatiere == null) {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Matière non trouvée avec l'ID: " + id)
                              .build();
            }
            
            matiere.setId(id);
            matiereDAO.mettre_a_jour(matiere);
            return Response.ok(matiere).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la mise à jour de la matière: " + e.getMessage())
                          .build();
        }
    }
    
    @DELETE
    @Path("/{id}")
    public Response deleteMatiere(@PathParam("id") Long id) {
        try {
            Matiere matiere = matiereDAO.trouverParId(id);
            if (matiere == null) {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Matière non trouvée avec l'ID: " + id)
                              .build();
            }
            
            matiereDAO.supprimer(id);
            return Response.status(Response.Status.NO_CONTENT).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la suppression de la matière: " + e.getMessage())
                          .build();
        }
    }
}
