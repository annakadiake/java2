package com.gestionacademique.rest;

import java.sql.SQLException;
import java.util.List;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import com.gestionacademique.dao.NoteDAO;
import com.gestionacademique.model.Note;

@Path("/notes")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class NoteResource {
    
    private NoteDAO noteDAO = new NoteDAO();
    
    @GET
    @Path("/etudiant/{etudiantId}")
    public Response getNotesByEtudiant(@PathParam("etudiantId") Long etudiantId) {
        try {
            List<Note> notes = noteDAO.trouverParEtudiant(etudiantId);
            return Response.ok(notes).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération des notes par étudiant: " + e.getMessage())
                          .build();
        }
    }
    
    @GET
    @Path("/matiere/{matiereId}")
    public Response getNotesByMatiere(@PathParam("matiereId") Long matiereId) {
        try {
            List<Note> notes = noteDAO.trouverParMatiere(matiereId);
            return Response.ok(notes).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération des notes par matière: " + e.getMessage())
                          .build();
        }
    }
    
    @GET
    @Path("/{id}")
    public Response getNoteById(@PathParam("id") Long id) {
        try {
            Note note = noteDAO.trouverParId(id);
            if (note != null) {
                return Response.ok(note).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Note non trouvée avec l'ID: " + id)
                              .build();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la récupération de la note: " + e.getMessage())
                          .build();
        }
    }
    
    @POST
    public Response createNote(Note note) {
        try {
            Note newNote = noteDAO.inserer(note);
            return Response.status(Response.Status.CREATED)
                          .entity(newNote)
                          .build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la création de la note: " + e.getMessage())
                          .build();
        }
    }
    
    @PUT
    @Path("/{id}")
    public Response updateNote(@PathParam("id") Long id, Note note) {
        try {
            Note existingNote = noteDAO.trouverParId(id);
            if (existingNote == null) {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Note non trouvée avec l'ID: " + id)
                              .build();
            }
            
            note.setId(id);
            noteDAO.mettre_a_jour(note);
            return Response.ok(note).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la mise à jour de la note: " + e.getMessage())
                          .build();
        }
    }
    
    @DELETE
    @Path("/{id}")
    public Response deleteNote(@PathParam("id") Long id) {
        try {
            Note note = noteDAO.trouverParId(id);
            if (note == null) {
                return Response.status(Response.Status.NOT_FOUND)
                              .entity("Note non trouvée avec l'ID: " + id)
                              .build();
            }
            
            noteDAO.supprimer(id);
            return Response.status(Response.Status.NO_CONTENT).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors de la suppression de la note: " + e.getMessage())
                          .build();
        }
    }
    
    @GET
    @Path("/moyenne/etudiant/{etudiantId}")
    public Response getMoyenneByEtudiant(@PathParam("etudiantId") Long etudiantId) {
        try {
            float moyenne = noteDAO.calculerMoyenne(etudiantId);
            return Response.ok("{\"moyenne\": " + moyenne + "}").build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors du calcul de la moyenne: " + e.getMessage())
                          .build();
        }
    }
    
    @GET
    @Path("/moyenne-ponderee/etudiant/{etudiantId}")
    public Response getMoyennePondereeByEtudiant(@PathParam("etudiantId") Long etudiantId) {
        try {
            float moyennePonderee = noteDAO.calculerMoyennePonderee(etudiantId);
            return Response.ok("{\"moyennePonderee\": " + moyennePonderee + "}").build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                          .entity("Erreur lors du calcul de la moyenne pondérée: " + e.getMessage())
                          .build();
        }
    }
}