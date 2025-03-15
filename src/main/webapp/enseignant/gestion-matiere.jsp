<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Gestion de Matière" />
</jsp:include>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body d-flex justify-content-between align-items-center">
                <h3 class="card-title mb-0">
                    <i class="fas fa-cog me-2"></i>Gestion de la matière: <span id="titreMatiere"></span>
                </h3>
                <a href="${pageContext.request.contextPath}/enseignant/matieres.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-1"></i>Retour aux matières
                </a>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-3">
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="card-title mb-0">
                    <i class="fas fa-info-circle me-2"></i>Informations
                </h5>
            </div>
            <div class="card-body">
                <p><strong>Code:</strong> <span id="infoMatiereCode"></span></p>
                <p><strong>Coefficient:</strong> <span id="infoMatiereCoefficient"></span></p>
                <p><strong>Nombre d'étudiants:</strong> <span id="infoMatiereNbEtudiants"></span></p>
                <p><strong>Moyenne:</strong> <span id="infoMatiereMoyenne"></span>/20</p>
                <p><strong>Notes complétées:</strong> <span id="infoMatiereNotesCompletees"></span></p>
            </div>
        </div>
        
        <div class="list-group mb-4">
            <a href="#" class="list-group-item list-group-item-action active" id="nav-etudiants-link">
                <i class="fas fa-user-graduate me-2"></i>Étudiants et notes
            </a>
            <a href="#" class="list-group-item list-group-item-action" id="nav-absences-link">
                <i class="fas fa-calendar-times me-2"></i>Absences
            </a>
            <a href="#" class="list-group-item list-group-item-action" id="nav-documents-link">
                <i class="fas fa-file-alt me-2"></i>Documents
            </a>
        </div>
    </div>
    
    <div class="col-md-9">
        <!-- Onglet Étudiants et notes -->
        <div id="etudiants-tab" class="card mb-4">
            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                <h5 class="card-title mb-0">
                    <i class="fas fa-user-graduate me-2"></i>Étudiants et notes
                </h5>
                <div>
                    <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#ajouterNoteGroupeModal">
                        <i class="fas fa-plus-circle me-1"></i>Saisie rapide
                    </button>
                    <button type="button" class="btn btn-success btn-sm ms-2" data-bs-toggle="modal" data-bs-target="#exporterNotesModal">
                        <i class="fas fa-file-export me-1"></i>Exporter
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover" id="tableEtudiantsMatiere">
                        <thead>
                            <tr>
                                <th>Matricule</th>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Note</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="listeEtudiantsMatiere">
                            <!-- Liste des étudiants insérée dynamiquement -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <!-- Onglet Absences -->
        <div id="absences-tab" class="card mb-4" style="display: none;">
            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                <h5 class="card-title mb-0">
                    <i class="fas fa-calendar-times me-2"></i>Absences
                </h5>
                <div>
                    <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#ajouterAbsenceGroupeModal">
                        <i class="fas fa-plus-circle me-1"></i>Signaler absences
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover" id="tableAbsencesMatiere">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Matricule</th>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Justification</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="listeAbsencesMatiere">
                            <!-- Liste des absences insérée dynamiquement -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <!-- Onglet Documents -->
        <div id="documents-tab" class="card mb-4" style="display: none;">
            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                <h5 class="card-title mb-0">
                    <i class="fas fa-file-alt me-2"></i>Documents
                </h5>
                <div>
                    <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#ajouterDocumentModal">
                        <i class="fas fa-file-upload me-1"></i>Ajouter un document
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="list-group" id="listeDocumentsMatiere">
                    <!-- Liste des documents insérée dynamiquement -->
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Saisie Rapide de Notes -->
<div class="modal fade" id="ajouterNoteGroupeModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-clipboard-list me-2"></i>Saisie rapide des notes
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/EnseignantServlet" method="post">
                <input type="hidden" name="action" value="ajouterNotesGroupe">
                <input type="hidden" name="matiereId" id="matiereIdAjouterNotes">
                <div class="modal-body">
                    <p>Saisissez rapidement les notes pour tous les étudiants inscrits à cette matière.</p>
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Matricule</th>
                                    <th>Nom</th>
                                    <th>Prénom</th>
                                    <th>Note</th>
                                </tr>
                            </thead>
                            <tbody id="listeEtudiantsAjouterNotes">
                                <!-- Liste des étudiants insérée dynamiquement -->
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Enregistrer les notes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Exporter Notes -->
<div class="modal fade" id="exporterNotesModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title">
                    <i class="fas fa-file-export me-2"></i>Exporter les notes
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Choisissez le format d'exportation pour les notes de cette matière.</p>
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/EnseignantServlet?action=exporterNotes&format=pdf&matiereId=${param.id}" class="btn btn-danger">
                        <i class="fas fa-file-pdf me-1"></i>Exporter en PDF
                    </a>
                    <a href="${pageContext.request.contextPath}/EnseignantServlet?action=exporterNotes&format=excel&matiereId=${param.id}" class="btn btn-success">
                        <i class="fas fa-file-excel me-1"></i>Exporter en Excel
                    </a>
                    <a href="${pageContext.request.contextPath}/EnseignantServlet?action=exporterNotes&format=csv&matiereId=${param.id}" class="btn btn-primary">
                        <i class="fas fa-file-csv me-1"></i>Exporter en CSV
                    </a>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Signaler Absences Groupe -->
<div class="modal fade" id="ajouterAbsenceGroupeModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="fas fa-calendar-times me-2"></i>Signaler des absences
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/EnseignantServlet" method="post">
                <input type="hidden" name="action" value="ajouterAbsencesGroupe">
                <input type="hidden" name="matiereId" id="matiereIdAjouterAbsences">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="dateAbsenceGroupe" class="form-label">Date d'absence</label>
                        <input type="date" class="form-control" id="dateAbsenceGroupe" name="dateAbsence" required>
                    </div>
                    
                    <p>Cochez les étudiants absents à cette date :</p>
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Absent</th>
                                    <th>Matricule</th>
                                    <th>Nom</th>
                                    <th>Prénom</th>
                                </tr>
                            </thead>
                            <tbody id="listeEtudiantsAjouterAbsences">
                                <!-- Liste des étudiants insérée dynamiquement -->
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-danger">Enregistrer les absences</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Ajouter Document -->
<div class="modal fade" id="ajouterDocumentModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-file-upload me-2"></i>Ajouter un document
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/EnseignantServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="ajouterDocument">
                <input type="hidden" name="matiereId" id="matiereIdAjouterDocument">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="titreDocument" class="form-label">Titre du document</label>
                        <input type="text" class="form-control" id="titreDocument" name="titre" required>
                    </div>
                    <div class="mb-3">
                        <label for="descriptionDocument" class="form-label">Description</label>
                        <textarea class="form-control" id="descriptionDocument" name="description" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="typeDocument" class="form-label">Type de document</label>
                        <select class="form-select" id="typeDocument" name="type" required>
                            <option value="cours">Support de cours</option>
                            <option value="td">Travaux dirigés</option>
                            <option value="tp">Travaux pratiques</option>
                            <option value="examen">Examen</option>
                            <option value="autre">Autre</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="fichierDocument" class="form-label">Fichier</label>
                        <input type="file" class="form-control" id="fichierDocument" name="fichier" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Ajouter le document</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // ID de la matière depuis l'URL
    var matiereId = new URLSearchParams(window.location.search).get('id');
    
    // Charger les informations de la matière
    function chargerInfosMatiere() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/matieres/' + matiereId,
            type: 'GET',
            success: function(matiere) {
                // Titre et informations
                document.title = "Gestion de " + matiere.nom + " - Système Académique";
                $('#titreMatiere').text(matiere.nom);
                $('#infoMatiereCode').text(matiere.code);
                $('#infoMatiereCoefficient').text(matiere.coefficient);
                $('#infoMatiereNbEtudiants').text(matiere.nbEtudiants || '0');
                
                // IDs pour les modales
                $('#matiereIdAjouterNotes').val(matiereId);
                $('#matiereIdAjouterAbsences').val(matiereId);
                $('#matiereIdAjouterDocument').val(matiereId);
                
                // Statistiques
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/matieres/' + matiereId + '/stats',
                    type: 'GET',
                    success: function(stats) {
                        $('#infoMatiereMoyenne').text(stats.moyenne.toFixed(2));
                        $('#infoMatiereNotesCompletees').text(stats.nbNotesCompletees + '/' + matiere.nbEtudiants);
                    }
                });
            },
            error: function() {
                alert('Erreur lors du chargement des informations de la matière');
                window.location.href = '${pageContext.request.contextPath}/enseignant/matieres.jsp';
            }
        });
    }
    
    // Charger les étudiants inscrits
    function chargerEtudiantsMatiere() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/matieres/' + matiereId + '/etudiants',
            type: 'GET',
            success: function(etudiants) {
                var html = '';
                var htmlAjouterNotes = '';
                var htmlAjouterAbsences = '';
                
                if (etudiants && etudiants.length > 0) {
                    etudiants.forEach(function(etudiant) {
                        // Tableau principal
                        html += '<tr>';
                        html += '<td>' + etudiant.matricule + '</td>';
                        html += '<td>' + etudiant.nom + '</td>';
                        html += '<td>' + etudiant.prenom + '</td>';
                        html += '<td>';
                        if (etudiant.note) {
                            var noteClass = '';
                            if (etudiant.note >= 16) {
                                noteClass = 'text-success';
                            } else if (etudiant.note >= 12) {
                                noteClass = 'text-info';
                            } else if (etudiant.note >= 10) {
                                noteClass = 'text-warning';
                            } else {
                                noteClass = 'text-danger';
                            }
                            html += '<span class="' + noteClass + '"><strong>' + etudiant.note + '/20</strong></span>';
                        } else {
                            html += '<span class="text-muted">Non notée</span>';
                        }
                        html += '</td>';
                        html += '<td>';
                        html += '<div class="btn-group btn-group-sm" role="group">';
                        html += '<button type="button" class="btn btn-primary" onclick="ajouterNote(' + etudiant.id + ', \'' + etudiant.prenom + ' ' + etudiant.nom + '\')">';
                        html += '<i class="fas fa-pen"></i>';
                        html += '</button>';
                        html += '<button type="button" class="btn btn-danger" onclick="signalerAbsence(' + etudiant.id + ', \'' + etudiant.prenom + ' ' + etudiant.nom + '\')">';
                        html += '<i class="fas fa-calendar-times"></i>';
                        html += '</button>';
                        html += '</div>';
                        html += '</td>';
                        html += '</tr>';
                        
                        // Formulaire d'ajout de notes en groupe
                        htmlAjouterNotes += '<tr>';
                        htmlAjouterNotes += '<td>' + etudiant.matricule + '</td>';
                        htmlAjouterNotes += '<td>' + etudiant.nom + '</td>';
                        htmlAjouterNotes += '<td>' + etudiant.prenom + '</td>';
                        htmlAjouterNotes += '<td>';
                        htmlAjouterNotes += '<input type="hidden" name="etudiantIds[]" value="' + etudiant.id + '">';
                        htmlAjouterNotes += '<input type="number" class="form-control" name="notes[]" min="0" max="20" step="0.25" value="' + (etudiant.note || '') + '">';
                        htmlAjouterNotes += '</td>';
                        htmlAjouterNotes += '</tr>';
                        
                        // Formulaire d'ajout d'absences en groupe
                        htmlAjouterAbsences += '<tr>';
                        htmlAjouterAbsences += '<td>';
                        htmlAjouterAbsences += '<div class="form-check">';
                        htmlAjouterAbsences += '<input class="form-check-input" type="checkbox" name="etudiantsAbsents[]" value="' + etudiant.id + '" id="checkAbsent' + etudiant.id + '">';
                        htmlAjouterAbsences += '</div>';
                        htmlAjouterAbsences += '</td>';
                        htmlAjouterAbsences += '<td>' + etudiant.matricule + '</td>';
                        htmlAjouterAbsences += '<td>' + etudiant.nom + '</td>';
                        htmlAjouterAbsences += '<td>' + etudiant.prenom + '</td>';
                        htmlAjouterAbsences += '</tr>';
                    });
                } else {
                    html = '<tr><td colspan="5" class="text-center">Aucun étudiant inscrit à cette matière</td></tr>';
                    htmlAjouterNotes = '<tr><td colspan="4" class="text-center">Aucun étudiant inscrit à cette matière</td></tr>';
                    htmlAjouterAbsences = '<tr><td colspan="4" class="text-center">Aucun étudiant inscrit à cette matière</td></tr>';
                }
                
                $('#listeEtudiantsMatiere').html(html);
                $('#listeEtudiantsAjouterNotes').html(htmlAjouterNotes);
                $('#listeEtudiantsAjouterAbsences').html(htmlAjouterAbsences);
            },
            error: function() {
                $('#listeEtudiantsMatiere').html('<tr><td colspan="5" class="text-center">Erreur lors du chargement des étudiants</td></tr>');
            }
        });
    }
    
    // Charger les absences
    function chargerAbsencesMatiere() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/matieres/' + matiereId + '/absences',
            type: 'GET',
            success: function(absences) {
                var html = '';
                
                if (absences && absences.length > 0) {
                    absences.forEach(function(absence) {
                        html += '<tr>';
                        html += '<td>' + new Date(absence.dateAbsence).toLocaleDateString() + '</td>';
                        html += '<td>' + absence.etudiant.matricule + '</td>';
                        html += '<td>' + absence.etudiant.nom + '</td>';
                        html += '<td>' + absence.etudiant.prenom + '</td>';
                        html += '<td>';
                        if (absence.justification) {
                            html += '<span class="text-success"><i class="fas fa-check-circle me-1"></i>' + absence.justification + '</span>';
                        } else {
                            html += '<span class="text-danger"><i class="fas fa-times-circle me-1"></i>Non justifiée</span>';
                        }
                        html += '</td>';
                        html += '<td>';
                        html += '<div class="btn-group btn-group-sm" role="group">';
                        html += '<button type="button" class="btn btn-warning" onclick="modifierAbsence(' + absence.id + ')">';
                        html += '<i class="fas fa-edit"></i>';
                        html += '</button>';
                        html += '<button type="button" class="btn btn-danger" onclick="supprimerAbsence(' + absence.id + ')">';
                        html += '<i class="fas fa-trash-alt"></i>';
                        html += '</button>';
                        html += '</div>';
                        html += '</td>';
                        html += '</tr>';
                    });
                } else {
                    html = '<tr><td colspan="6" class="text-center">Aucune absence enregistrée pour cette matière</td></tr>';
                }
                
                $('#listeAbsencesMatiere').html(html);
            },
            error: function() {
                $('#listeAbsencesMatiere').html('<tr><td colspan="6" class="text-center">Erreur lors du chargement des absences</td></tr>');
            }
        });
    }
    
    // Charger les documents
    function chargerDocumentsMatiere() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/matieres/' + matiereId + '/documents',
            type: 'GET',
            success: function(documents) {
                var html = '';
                
                if (documents && documents.length > 0) {
                    documents.forEach(function(doc) {
                        html += '<div class="list-group-item list-group-item-action">';
                        html += '<div class="d-flex w-100 justify-content-between">';
                        html += '<h5 class="mb-1">' + doc.titre + '</h5>';
                        html += '<small>' + new Date(doc.dateAjout).toLocaleDateString() + '</small>';
                        html += '</div>';
                        html += '<p class="mb-1">' + (doc.description || 'Aucune description') + '</p>';
                        html += '<div class="d-flex justify-content-between align-items-center">';
                        html += '<small>Type: ' + doc.type + ' | Taille: ' + formatTaille(doc.taille) + '</small>';
                        html += '<div class="btn-group btn-group-sm" role="group">';
                        html += '<a href="${pageContext.request.contextPath}/EnseignantServlet?action=telechargerDocument&documentId=' + doc.id + '" class="btn btn-primary">';
                        html += '<i class="fas fa-download me-1"></i>Télécharger';
                        html += '</a>';
                        html += '<button type="button" class="btn btn-danger" onclick="supprimerDocument(' + doc.id + ')">';
                        html += '<i class="fas fa-trash-alt me-1"></i>Supprimer';
                        html += '</button>';
                        html += '</div>';
                        html += '</div>';
                        html += '</div>';
                    });
                } else {
                    html = '<div class="list-group-item">Aucun document disponible pour cette matière</div>';
                }
                
                $('#listeDocumentsMatiere').html(html);
            },
            error: function() {
                $('#listeDocumentsMatiere').html('<div class="list-group-item">Erreur lors du chargement des documents</div>');
            }
        });
    }
    
    // Formater la taille du fichier
    function formatTaille(taille) {
        if (taille < 1024) {
            return taille + ' octets';
        } else if (taille < 1024 * 1024) {
            return (taille / 1024).toFixed(2) + ' Ko';
        } else {
            return (taille / (1024 * 1024)).toFixed(2) + ' Mo';
        }
    }
    
    // Navigation entre ong
     $('#nav-etudiants-link').click(function(e) {
        e.preventDefault();
        $(this).addClass('active').siblings().removeClass('active');
        $('#etudiants-tab').show().siblings('.card').hide();
    });
    
    $('#nav-absences-link').click(function(e) {
        e.preventDefault();
        $(this).addClass('active').siblings().removeClass('active');
        $('#absences-tab').show().siblings('.card').hide();
    });
    
    $('#nav-documents-link').click(function(e) {
        e.preventDefault();
        $(this).addClass('active').siblings().removeClass('active');
        $('#documents-tab').show().siblings('.card').hide();
    });
    
    // Ajouter une note (modal dynamique)
    function ajouterNote(etudiantId, etudiantNom) {
        // Créer un modal dynamiquement
        var modalId = 'ajouterNoteModal' + etudiantId;
        
        // Supprimer le modal précédent s'il existe
        $('#' + modalId).remove();
        
        // Créer le nouveau modal
        var modal = $('<div class="modal fade" id="' + modalId + '" tabindex="-1"></div>');
        var modalDialog = $('<div class="modal-dialog"></div>');
        var modalContent = $('<div class="modal-content"></div>');
        
        // En-tête
        var modalHeader = $('<div class="modal-header bg-primary text-white"></div>');
        modalHeader.append('<h5 class="modal-title"><i class="fas fa-pen me-2"></i>Ajouter une note pour ' + etudiantNom + '</h5>');
        modalHeader.append('<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>');
        
        // Formulaire
        var form = $('<form></form>');
        form.attr('action', '${pageContext.request.contextPath}/EnseignantServlet');
        form.attr('method', 'post');
        
        // Corps
        var modalBody = $('<div class="modal-body"></div>');
        modalBody.append('<input type="hidden" name="action" value="ajouterNote">');
        modalBody.append('<input type="hidden" name="etudiantId" value="' + etudiantId + '">');
        modalBody.append('<input type="hidden" name="matiereId" value="' + matiereId + '">');
        
        var formGroup = $('<div class="mb-3"></div>');
        formGroup.append('<label for="valeurNote' + etudiantId + '" class="form-label">Note (sur 20)</label>');
        formGroup.append('<input type="number" class="form-control" id="valeurNote' + etudiantId + '" name="valeur" min="0" max="20" step="0.25" required>');
        modalBody.append(formGroup);
        
        // Pied
        var modalFooter = $('<div class="modal-footer"></div>');
        modalFooter.append('<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>');
        modalFooter.append('<button type="submit" class="btn btn-primary">Ajouter</button>');
        
        // Assembler le modal
        form.append(modalBody);
        form.append(modalFooter);
        modalContent.append(modalHeader);
        modalContent.append(form);
        modalDialog.append(modalContent);
        modal.append(modalDialog);
        
        // Ajouter au DOM et afficher
        $('body').append(modal);
        var modalObj = new bootstrap.Modal(document.getElementById(modalId));
        modalObj.show();
    }
    
    // Signaler une absence (modal dynamique)
    function signalerAbsence(etudiantId, etudiantNom) {
        // Créer un modal dynamiquement
        var modalId = 'signalerAbsenceModal' + etudiantId;
        
        // Supprimer le modal précédent s'il existe
        $('#' + modalId).remove();
        
        // Créer le nouveau modal
        var modal = $('<div class="modal fade" id="' + modalId + '" tabindex="-1"></div>');
        var modalDialog = $('<div class="modal-dialog"></div>');
        var modalContent = $('<div class="modal-content"></div>');
        
        // En-tête
        var modalHeader = $('<div class="modal-header bg-danger text-white"></div>');
        modalHeader.append('<h5 class="modal-title"><i class="fas fa-calendar-times me-2"></i>Signaler une absence pour ' + etudiantNom + '</h5>');
        modalHeader.append('<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>');
        
        // Formulaire
        var form = $('<form></form>');
        form.attr('action', '${pageContext.request.contextPath}/EnseignantServlet');
        form.attr('method', 'post');
        
        // Corps
        var modalBody = $('<div class="modal-body"></div>');
        modalBody.append('<input type="hidden" name="action" value="ajouterAbsence">');
        modalBody.append('<input type="hidden" name="etudiantId" value="' + etudiantId + '">');
        modalBody.append('<input type="hidden" name="matiereId" value="' + matiereId + '">');
        
        var formGroup1 = $('<div class="mb-3"></div>');
        formGroup1.append('<label for="dateAbsence' + etudiantId + '" class="form-label">Date d\'absence</label>');
        formGroup1.append('<input type="date" class="form-control" id="dateAbsence' + etudiantId + '" name="dateAbsence" required>');
        modalBody.append(formGroup1);
        
        var formGroup2 = $('<div class="mb-3"></div>');
        formGroup2.append('<label for="justification' + etudiantId + '" class="form-label">Justification (optionnel)</label>');
        formGroup2.append('<textarea class="form-control" id="justification' + etudiantId + '" name="justification" rows="3"></textarea>');
        modalBody.append(formGroup2);
        
        // Pied
        var modalFooter = $('<div class="modal-footer"></div>');
        modalFooter.append('<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>');
        modalFooter.append('<button type="submit" class="btn btn-danger">Signaler</button>');
        
        // Assembler le modal
        form.append(modalBody);
        form.append(modalFooter);
        modalContent.append(modalHeader);
        modalContent.append(form);
        modalDialog.append(modalContent);
        modal.append(modalDialog);
        
        // Ajouter au DOM et afficher
        $('body').append(modal);
        var modalObj = new bootstrap.Modal(document.getElementById(modalId));
        modalObj.show();
    }
    
    // Modifier une absence
    function modifierAbsence(absenceId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/absences/' + absenceId,
            type: 'GET',
            success: function(absence) {
                // Créer un modal dynamiquement
                var modalId = 'modifierAbsenceModal' + absenceId;
                
                // Supprimer le modal précédent s'il existe
                $('#' + modalId).remove();
                
                // Créer le nouveau modal
                var modal = $('<div class="modal fade" id="' + modalId + '" tabindex="-1"></div>');
                var modalDialog = $('<div class="modal-dialog"></div>');
                var modalContent = $('<div class="modal-content"></div>');
                
                // En-tête
                var modalHeader = $('<div class="modal-header bg-warning"></div>');
                modalHeader.append('<h5 class="modal-title"><i class="fas fa-edit me-2"></i>Modifier une absence</h5>');
                modalHeader.append('<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>');
                
                // Formulaire
                var form = $('<form></form>');
                form.attr('action', '${pageContext.request.contextPath}/EnseignantServlet');
                form.attr('method', 'post');
                
                // Corps
                var modalBody = $('<div class="modal-body"></div>');
                modalBody.append('<input type="hidden" name="action" value="modifierAbsence">');
                modalBody.append('<input type="hidden" name="absenceId" value="' + absenceId + '">');
                
                var infoEtudiant = $('<p></p>');
                infoEtudiant.append('<strong>Étudiant: </strong>' + absence.etudiant.prenom + ' ' + absence.etudiant.nom);
                modalBody.append(infoEtudiant);
                
                var formGroup1 = $('<div class="mb-3"></div>');
                formGroup1.append('<label for="modifierDateAbsence' + absenceId + '" class="form-label">Date d\'absence</label>');
                var dateInput = $('<input type="date" class="form-control" id="modifierDateAbsence' + absenceId + '" name="dateAbsence" required>');
                dateInput.val(formatDate(absence.dateAbsence));
                formGroup1.append(dateInput);
                modalBody.append(formGroup1);
                
                var formGroup2 = $('<div class="mb-3"></div>');
                formGroup2.append('<label for="modifierJustification' + absenceId + '" class="form-label">Justification (optionnel)</label>');
                var justificationTextarea = $('<textarea class="form-control" id="modifierJustification' + absenceId + '" name="justification" rows="3"></textarea>');
                justificationTextarea.val(absence.justification || '');
                formGroup2.append(justificationTextarea);
                modalBody.append(formGroup2);
                
                // Pied
                var modalFooter = $('<div class="modal-footer"></div>');
                modalFooter.append('<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>');
                modalFooter.append('<button type="submit" class="btn btn-warning">Enregistrer les modifications</button>');
                
                // Assembler le modal
                form.append(modalBody);
                form.append(modalFooter);
                modalContent.append(modalHeader);
                modalContent.append(form);
                modalDialog.append(modalContent);
                modal.append(modalDialog);
                
                // Ajouter au DOM et afficher
                $('body').append(modal);
                var modalObj = new bootstrap.Modal(document.getElementById(modalId));
                modalObj.show();
            },
            error: function() {
                alert('Erreur lors du chargement des données de l\'absence');
            }
        });
    }
    
    // Supprimer une absence
    function supprimerAbsence(absenceId) {
        if (confirm('Êtes-vous sûr de vouloir supprimer cette absence ?')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/EnseignantServlet',
                type: 'POST',
                data: {
                    action: 'supprimerAbsence',
                    absenceId: absenceId
                },
                success: function() {
                    chargerAbsencesMatiere();
                },
                error: function() {
                    alert('Erreur lors de la suppression de l\'absence');
                }
            });
        }
    }
    
    // Supprimer un document
    function supprimerDocument(documentId) {
        if (confirm('Êtes-vous sûr de vouloir supprimer ce document ?')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/EnseignantServlet',
                type: 'POST',
                data: {
                    action: 'supprimerDocument',
                    documentId: documentId
                },
                success: function() {
                    chargerDocumentsMatiere();
                },
                error: function() {
                    alert('Erreur lors de la suppression du document');
                }
            });
        }
    }
    
    // Formater la date pour l'entrée date HTML
    function formatDate(date) {
        if (typeof date === 'string') {
            return date;
        }
        
        var d = new Date(date);
        var month = '' + (d.getMonth() + 1);
        var day = '' + d.getDate();
        var year = d.getFullYear();
        
        if (month.length < 2) 
            month = '0' + month;
        if (day.length < 2) 
            day = '0' + day;
        
        return [year, month, day].join('-');
    }
    
    // Initialisation
    $(document).ready(function() {
        if (!matiereId) {
            alert('ID de matière manquant dans l\'URL');
            window.location.href = '${pageContext.request.contextPath}/enseignant/matieres.jsp';
            return;
        }
        
        chargerInfosMatiere();
        chargerEtudiantsMatiere();
        chargerAbsencesMatiere();
        chargerDocumentsMatiere();
        
        // Définir la date du jour pour les formulaires d'absence
        document.getElementById('dateAbsenceGroupe').valueAsDate = new Date();
    });
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />