<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Gestion des Étudiants" />
</jsp:include>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body d-flex justify-content-between align-items-center">
                <h3 class="card-title mb-0">
                    <i class="fas fa-user-graduate me-2"></i>Gestion des Étudiants
                </h3>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#ajouterEtudiantModal">
                    <i class="fas fa-plus-circle me-1"></i>Ajouter un étudiant
                </button>
            </div>
        </div>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header bg-light">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-list me-2"></i>Liste des étudiants
                        </h5>
                    </div>
                    <div class="col-md-6">
                        <input type="text" id="searchEtudiant" class="form-control" placeholder="Rechercher un étudiant...">
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover" id="tableEtudiants">
                        <thead>
                            <tr>
                                <th>Matricule</th>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Email</th>
                                <th>Filière</th>
                                <th>Niveau</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="etudiant" items="${etudiants}">
                                <tr>
                                    <td>${etudiant.matricule}</td>
                                    <td>${etudiant.nom}</td>
                                    <td>${etudiant.prenom}</td>
                                    <td>${etudiant.email}</td>
                                    <td>${etudiant.filiere}</td>
                                    <td>${etudiant.niveau}</td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <button type="button" class="btn btn-primary" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#detailsEtudiantModal" 
                                                    data-id="${etudiant.id}">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button type="button" class="btn btn-warning" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#modifierEtudiantModal" 
                                                    data-id="${etudiant.id}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button type="button" class="btn btn-danger" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#supprimerEtudiantModal" 
                                                    data-id="${etudiant.id}">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Ajouter Étudiant -->
<div class="modal fade" id="ajouterEtudiantModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-plus-circle me-2"></i>Ajouter un étudiant
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                <input type="hidden" name="action" value="ajouterEtudiant">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="matriculeModal" class="form-label">Matricule</label>
                        <input type="text" class="form-control" id="matriculeModal" name="matricule" required>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="nomModal" class="form-label">Nom</label>
                            <input type="text" class="form-control" id="nomModal" name="nom" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="prenomModal" class="form-label">Prénom</label>
                            <input type="text" class="form-control" id="prenomModal" name="prenom" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="emailModal" class="form-label">Email</label>
                        <input type="email" class="form-control" id="emailModal" name="email" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="dateNaissanceModal" class="form-label">Date de naissance</label>
                        <input type="date" class="form-control" id="dateNaissanceModal" name="dateNaissance">
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="filiereModal" class="form-label">Filière</label>
                            <input type="text" class="form-control" id="filiereModal" name="filiere" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="niveauModal" class="form-label">Niveau</label>
                            <select class="form-select" id="niveauModal" name="niveau" required>
                                <option value="">Sélectionner...</option>
                                <option value="Licence 1">Licence 1</option>
                                <option value="Licence 2">Licence 2</option>
                                <option value="Licence 3">Licence 3</option>
                                <option value="Master 1">Master 1</option>
                                <option value="Master 2">Master 2</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Ajouter</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Détails Étudiant -->
<div class="modal fade" id="detailsEtudiantModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title">
                    <i class="fas fa-user-graduate me-2"></i>Détails de l'étudiant
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h4 id="detailsNomPrenom"></h4>
                        <p class="mb-1"><strong>Matricule:</strong> <span id="detailsMatricule"></span></p>
                        <p class="mb-1"><strong>Email:</strong> <span id="detailsEmail"></span></p>
                        <p class="mb-1"><strong>Date de naissance:</strong> <span id="detailsDateNaissance"></span></p>
                        <p class="mb-1"><strong>Filière:</strong> <span id="detailsFiliere"></span></p>
                        <p class="mb-1"><strong>Niveau:</strong> <span id="detailsNiveau"></span></p>
                    </div>
                </div>
                
                <ul class="nav nav-tabs" id="etudiantDetailsTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="notes-tab" data-bs-toggle="tab" data-bs-target="#notes" type="button" role="tab">Notes</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="absences-tab" data-bs-toggle="tab" data-bs-target="#absences" type="button" role="tab">Absences</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="matieres-tab" data-bs-toggle="tab" data-bs-target="#matieres" type="button" role="tab">Matières</button>
                    </li>
                </ul>
                <div class="tab-content" id="etudiantDetailsContent">
                    <div class="tab-pane fade show active p-3" id="notes" role="tabpanel">
                        <!-- Contenu des notes -->
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Matière</th>
                                    <th>Note</th>
                                </tr>
                            </thead>
                            <tbody id="detailsNotesTable">
                                <!-- Notes insérées dynamiquement -->
                            </tbody>
                        </table>
                    </div>
                    <div class="tab-pane fade p-3" id="absences" role="tabpanel">
                        <!-- Contenu des absences -->
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Matière</th>
                                    <th>Date</th>
                                    <th>Justifiée</th>
                                </tr>
                            </thead>
                            <tbody id="detailsAbsencesTable">
                                <!-- Absences insérées dynamiquement -->
                            </tbody>
                        </table>
                    </div>
                    <div class="tab-pane fade p-3" id="matieres" role="tabpanel">
                        <!-- Contenu des matières -->
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Matière</th>
                                    <th>Code</th>
                                    <th>Coefficient</th>
                                    <th>Enseignant</th>
                                </tr>
                            </thead>
                            <tbody id="detailsMatieresTable">
                                <!-- Matières insérées dynamiquement -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Modifier Étudiant -->
<div class="modal fade" id="modifierEtudiantModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title">
                    <i class="fas fa-edit me-2"></i>Modifier l'étudiant
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                <input type="hidden" name="action" value="modifierEtudiant">
                <input type="hidden" name="id" id="modifierEtudiantId">
                <div class="modal-body">
                    <!-- Formulaire similaire à l'ajout mais avec des champs pré-remplis -->
                    <div class="mb-3">
                        <label for="modifierMatricule" class="form-label">Matricule</label>
                        <input type="text" class="form-control" id="modifierMatricule" name="matricule" required>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="modifierNom" class="form-label">Nom</label>
                            <input type="text" class="form-control" id="modifierNom" name="nom" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="modifierPrenom" class="form-label">Prénom</label>
                            <input type="text" class="form-control" id="modifierPrenom" name="prenom" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="modifierEmail" class="form-label">Email</label>
                        <input type="email" class="form-control" id="modifierEmail" name="email" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="modifierDateNaissance" class="form-label">Date de naissance</label>
                        <input type="date" class="form-control" id="modifierDateNaissance" name="dateNaissance">
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="modifierFiliere" class="form-label">Filière</label>
                            <input type="text" class="form-control" id="modifierFiliere" name="filiere" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="modifierNiveau" class="form-label">Niveau</label>
                            <select class="form-select" id="modifierNiveau" name="niveau" required>
                                <option value="">Sélectionner...</option>
                                <option value="Licence 1">Licence 1</option>
                                <option value="Licence 2">Licence 2</option>
                                <option value="Licence 3">Licence 3</option>
                                <option value="Master 1">Master 1</option>
                                <option value="Master 2">Master 2</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-warning">Enregistrer les modifications</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Supprimer Étudiant -->
<div class="modal fade" id="supprimerEtudiantModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="fas fa-trash-alt me-2"></i>Supprimer l'étudiant
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir supprimer cet étudiant ?</p>
                <p>Cette action est irréversible et supprimera également toutes les notes et absences associées.</p>
                <p class="text-danger"><strong>Étudiant à supprimer: </strong><span id="supprimerEtudiantNom"></span></p>
            </div>
            <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                <input type="hidden" name="action" value="supprimerEtudiant">
                <input type="hidden" name="id" id="supprimerEtudiantId">
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-danger">Confirmer la suppression</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Recherche d'étudiants
    document.getElementById('searchEtudiant').addEventListener('keyup', function() {
        var input = this.value.toLowerCase();
        var table = document.getElementById('tableEtudiants');
        var rows = table.getElementsByTagName('tr');
        
        for (var i = 1; i < rows.length; i++) {
            var found = false;
            var cells = rows[i].getElementsByTagName('td');
            
            for (var j = 0; j < cells.length - 1; j++) {
                var cellText = cells[j].textContent.toLowerCase();
                
                if (cellText.indexOf(input) > -1) {
                    found = true;
                    break;
                }
            }
            
            if (found) {
                rows[i].style.display = '';
            } else {
                rows[i].style.display = 'none';
            }
        }
    });

    // Détails d'un étudiant
    $('#detailsEtudiantModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        
        // Appel AJAX pour obtenir les détails de l'étudiant
        $.ajax({
            url: '${pageContext.request.contextPath}/api/etudiants/' + id,
            type: 'GET',
            success: function(etudiant) {
                $('#detailsNomPrenom').text(etudiant.prenom + ' ' + etudiant.nom);
                $('#detailsMatricule').text(etudiant.matricule);
                $('#detailsEmail').text(etudiant.email);
                $('#detailsDateNaissance').text(new Date(etudiant.dateNaissance).toLocaleDateString());
                $('#detailsFiliere').text(etudiant.filiere);
                $('#detailsNiveau').text(etudiant.niveau);
                
                // Récupérer les notes
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/notes/etudiant/' + id,
                    type: 'GET',
                    success: function(notes) {
                        var html = '';
                        var totalNotes = 0;
                        var totalCoef = 0;
                        
                        notes.forEach(function(note) {
                            html += '<tr>';
                            html += '<td>' + note.matiere.nom + '</td>';
                            html += '<td>' + note.valeur + '</td>';
                            html += '</tr>';
                            
                            totalNotes += note.valeur * note.matiere.coefficient;
                            totalCoef += note.matiere.coefficient;
                        });
                        
                        // Ajouter la moyenne
                        if (totalCoef > 0) {
                            var moyenne = totalNotes / totalCoef;
                            html += '<tr class="table-primary">';
                            html += '<td><strong>Moyenne</strong></td>';
                            html += '<td><strong>' + moyenne.toFixed(2) + '</strong></td>';
                            html += '</tr>';
                        }
                        
                        $('#detailsNotesTable').html(html);
                    },
                    error: function() {
                        $('#detailsNotesTable').html('<tr><td colspan="2" class="text-center">Erreur lors du chargement des notes</td></tr>');
                    }
                });
                
                // Récupérer les absences
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/absences/etudiant/' + id,
                    type: 'GET',
                    success: function(absences) {
                        var html = '';
                        
                        absences.forEach(function(absence) {
                            html += '<tr>';
                            html += '<td>' + absence.matiere.nom + '</td>';
                            html += '<td>' + new Date(absence.dateAbsence).toLocaleDateString() + '</td>';
                            html += '<td>' + (absence.justification ? 'Oui' : 'Non') + '</td>';
                            html += '</tr>';
                        });
                        
                        if (absences.length === 0) {
                            html = '<tr><td colspan="3" class="text-center">Aucune absence enregistrée</td></tr>';
                        }
                        
                        $('#detailsAbsencesTable').html(html);
                    },
                    error: function() {
                        $('#detailsAbsencesTable').html('<tr><td colspan="3" class="text-center">Erreur lors du chargement des absences</td></tr>');
                    }
                });
                
                // Récupérer les matières
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/matieres/etudiant/' + id,
                    type: 'GET',
                    success: function(matieres) {
                        var html = '';
                        
                        matieres.forEach(function(matiere) {
                            html += '<tr>';
                            html += '<td>' + matiere.nom + '</td>';
                            html += '<td>' + matiere.code + '</td>';
                            html += '<td>' + matiere.coefficient + '</td>';
                            html += '<td>' + (matiere.enseignant ? matiere.enseignant.prenom + ' ' + matiere.enseignant.nom : 'Non assigné') + '</td>';
                            html += '</tr>';
                        });
                        
                        if (matieres.length === 0) {
                            html = '<tr><td colspan="4" class="text-center">Aucune matière inscrite</td></tr>';
                        }
                        
                        $('#detailsMatieresTable').html(html);
                    },
                    error: function() {
                        $('#detailsMatieresTable').html('<tr><td colspan="4" class="text-center">Erreur lors du chargement des matières</td></tr>');
                    }
                });
            },
            error: function() {
                alert('Erreur lors du chargement des données de l\'étudiant');
            }
        });
    });

    // Modifier un étudiant
    $('#modifierEtudiantModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        
        // Appel AJAX pour obtenir les données de l'étudiant
        $.ajax({
            url: '${pageContext.request.contextPath}/api/etudiants/' + id,
            type: 'GET',
            success: function(etudiant) {
                $('#modifierEtudiantId').val(etudiant.id);
                $('#modifierMatricule').val(etudiant.matricule);
                $('#modifierNom').val(etudiant.nom);
                $('#modifierPrenom').val(etudiant.prenom);
                $('#modifierEmail').val(etudiant.email);
                $('#modifierDateNaissance').val(etudiant.dateNaissance ? new Date(etudiant.dateNaissance).toISOString().split('T')[0] : '');
                $('#modifierFiliere').val(etudiant.filiere);
                $('#modifierNiveau').val(etudiant.niveau);
            },
            error: function() {
                alert('Erreur lors du chargement des données de l\'étudiant');
                $('#modifierEtudiantModal').modal('hide');
            }
        });
    });

    // Supprimer un étudiant
    $('#supprimerEtudiantModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        
        // Appel AJAX pour obtenir le nom de l'étudiant
        $.ajax({
            url: '${pageContext.request.contextPath}/api/etudiants/' + id,
            type: 'GET',
            success: function(etudiant) {
                $('#supprimerEtudiantId').val(etudiant.id);
                $('#supprimerEtudiantNom').text(etudiant.prenom + ' ' + etudiant.nom + ' (' + etudiant.matricule + ')');
            },
            error: function() {
                alert('Erreur lors du chargement des données de l\'étudiant');
                $('#supprimerEtudiantModal').modal('hide');
            }
        });
    });
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />