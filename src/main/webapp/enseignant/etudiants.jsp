<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Mes Étudiants" />
</jsp:include>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body">
                <h3 class="card-title">
                    <i class="fas fa-user-graduate me-2"></i>Mes Étudiants
                </h3>
                <p class="card-text">Consultez la liste des étudiants inscrits à vos matières.</p>
            </div>
        </div>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header bg-light">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-filter me-2"></i>Filtrer
                        </h5>
                    </div>
                    <div class="col-md-4">
                        <select id="matiereFilter" class="form-select">
                            <option value="">Toutes les matières</option>
                            <c:forEach var="matiere" items="${matieres}">
                                <option value="${matiere.id}">${matiere.nom} (${matiere.code})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
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
                                <th>Filière</th>
                                <th>Niveau</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="etudiant" items="${etudiants}">
                                <tr data-matieres="${etudiant.matiereIds}">
                                    <td>${etudiant.matricule}</td>
                                    <td>${etudiant.nom}</td>
                                    <td>${etudiant.prenom}</td>
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
                                            <button type="button" class="btn btn-info" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#notesEtudiantModal" 
                                                    data-id="${etudiant.id}">
                                                <i class="fas fa-clipboard-list"></i>
                                            </button>
                                            <button type="button" class="btn btn-danger" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#absencesEtudiantModal" 
                                                    data-id="${etudiant.id}">
                                                <i class="fas fa-calendar-times"></i>
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

<!-- Modal Détails Étudiant -->
<div class="modal fade" id="detailsEtudiantModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-user-graduate me-2"></i>Détails de l'étudiant
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h4 id="detailsEtudiantNomPrenom"></h4>
                        <p class="mb-1"><strong>Matricule:</strong> <span id="detailsEtudiantMatricule"></span></p>
                        <p class="mb-1"><strong>Email:</strong> <span id="detailsEtudiantEmail"></span></p>
                        <p class="mb-1"><strong>Date de naissance:</strong> <span id="detailsEtudiantDateNaissance"></span></p>
                        <p class="mb-1"><strong>Filière:</strong> <span id="detailsEtudiantFiliere"></span></p>
                        <p class="mb-1"><strong>Niveau:</strong> <span id="detailsEtudiantNiveau"></span></p>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Matières suivies avec vous</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Matière</th>
                                        <th>Code</th>
                                        <th>Note</th>
                                        <th>Absences</th>
                                    </tr>
                                </thead>
                                <tbody id="detailsEtudiantMatieresTable">
                                    <!-- Matières insérées dynamiquement -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Notes Étudiant -->
<div class="modal fade" id="notesEtudiantModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title">
                    <i class="fas fa-clipboard-list me-2"></i>Notes de l'étudiant
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <h5 id="notesEtudiantNomPrenom" class="mb-3"></h5>
                
                <form action="${pageContext.request.contextPath}/EnseignantServlet" method="post">
                    <input type="hidden" name="action" value="ajouterNotesEtudiant">
                    <input type="hidden" name="etudiantId" id="notesEtudiantId">
                    
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Matière</th>
                                    <th>Note/20</th>
                                </tr>
                            </thead>
                            <tbody id="notesEtudiantTable">
                                <!-- Notes insérées dynamiquement -->
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="d-grid gap-2 mt-3">
                        <button type="submit" class="btn btn-primary">Enregistrer les notes</button>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Absences Étudiant -->
<div class="modal fade" id="absencesEtudiantModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="fas fa-calendar-times me-2"></i>Absences de l'étudiant
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 id="absencesEtudiantNomPrenom"></h5>
                    <button type="button" class="btn btn-danger btn-sm" id="ajouterAbsenceEtudiantBtn">
                        <i class="fas fa-plus-circle me-1"></i>Signaler une absence
                    </button>
                </div>
                
                <div id="formAjouterAbsenceEtudiant" style="display: none;" class="card mb-3">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/EnseignantServlet" method="post">
                            <input type="hidden" name="action" value="ajouterAbsence">
                            <input type="hidden" name="etudiantId" id="absencesEtudiantId">
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="absenceMatiereId" class="form-label">Matière</label>
                                    <select id="absenceMatiereId" name="matiereId" class="form-select" required>
                                        <!-- Matières insérées dynamiquement -->
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="absenceDateAbsence" class="form-label">Date d'absence</label>
                                    <input type="date" class="form-control" id="absenceDateAbsence" name="dateAbsence" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="absenceJustification" class="form-label">Justification (optionnel)</label>
                                <textarea class="form-control" id="absenceJustification" name="justification" rows="2"></textarea>
                            </div>
                            
                            <div class="d-flex justify-content-between">
                                <button type="button" class="btn btn-secondary" id="annulerAbsenceEtudiantBtn">Annuler</button>
                                <button type="submit" class="btn btn-danger">Signaler l'absence</button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Matière</th>
                                <th>Justification</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="absencesEtudiantTable">
                            <!-- Absences insérées dynamiquement -->
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>

<script>
    // Filtrer par matière
    document.getElementById('matiereFilter').addEventListener('change', function() {
        var matiereId = this.value;
        var table = document.getElementById('tableEtudiants');
        var rows = table.getElementsByTagName('tr');
        
        for (var i = 1; i < rows.length; i++) {
            var matieres = rows[i].getAttribute('data-matieres');
            
            if (matiereId === '' || (matieres && matieres.includes(matiereId))) {
                rows[i].style.display = '';
            } else {
                rows[i].style.display = 'none';
            }
        }
    });
    
    // Rechercher un étudiant
    document.getElementById('searchEtudiant').addEventListener('keyup', function() {
        var input = this.value.toLowerCase();
        var table = document.getElementById('tableEtudiants');
        var rows = table.getElementsByTagName('tr');
        
        for (var i = 1; i < rows.length; i++) {
            var found = false;
            var cells = rows[i].getElementsByTagName('td');
            
            for (var j = 0; j < 5; j++) { // Exclure la colonne Actions
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
                $('#detailsEtudiantNomPrenom').text(etudiant.prenom + ' ' + etudiant.nom);
                $('#detailsEtudiantMatricule').text(etudiant.matricule);
                $('#detailsEtudiantEmail').text(etudiant.email);
                $('#detailsEtudiantDateNaissance').text(new Date(etudiant.dateNaissance).toLocaleDateString());
                $('#detailsEtudiantFiliere').text(etudiant.filiere);
                $('#detailsEtudiantNiveau').text(etudiant.niveau);
                
                // Récupérer les matières et les notes
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/enseignants/current/etudiants/' + id + '/matieres',
                    type: 'GET',
                    success: function(matieres) {
                        var html = '';
                        
                        if (matieres && matieres.length > 0) {
                            matieres.forEach(function(matiere) {
                                html += '<tr>';
                                html += '<td>' + matiere.nom + '</td>';
                                html += '<td>' + matiere.code + '</td>';
                                html += '<td>';
                                if (matiere.note) {
                                    var noteClass = '';
                                    if (matiere.note >= 16) {
                                        noteClass = 'text-success';
                                    } else if (matiere.note >= 12) {
                                        noteClass = 'text-info';
                                    } else if (matiere.note >= 10) {
                                        noteClass = 'text-warning';
                                    } else {
                                        noteClass = 'text-danger';
                                    }html += '<span class="' + noteClass + '"><strong>' + matiere.note + '/20</strong></span>';
                                } else {
                                    html += '<span class="text-muted">Non notée</span>';
                                }
                                html += '</td>';
                                html += '<td>' + (matiere.nbAbsences || '0') + '</td>';
                                html += '</tr>';
                            });
                        } else {
                            html = '<tr><td colspan="4" class="text-center">Aucune matière suivie avec vous</td></tr>';
                        }
                        
                        $('#detailsEtudiantMatieresTable').html(html);
                    },
                    error: function() {
                        $('#detailsEtudiantMatieresTable').html('<tr><td colspan="4" class="text-center">Erreur lors du chargement des matières</td></tr>');
                    }
                });
            },
            error: function() {
                alert('Erreur lors du chargement des données de l\'étudiant');
            }
        });
    });
    
    // Notes d'un étudiant
    $('#notesEtudiantModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        
        $('#notesEtudiantId').val(id);
        
        // Appel AJAX pour obtenir les détails de l'étudiant et ses notes
        $.ajax({
            url: '${pageContext.request.contextPath}/api/etudiants/' + id,
            type: 'GET',
            success: function(etudiant) {
                $('#notesEtudiantNomPrenom').text(etudiant.prenom + ' ' + etudiant.nom);
                
                // Récupérer les matières et les notes
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/enseignants/current/etudiants/' + id + '/matieres',
                    type: 'GET',
                    success: function(matieres) {
                        var html = '';
                        
                        if (matieres && matieres.length > 0) {
                            matieres.forEach(function(matiere) {
                                html += '<tr>';
                                html += '<td>' + matiere.nom + ' (' + matiere.code + ')</td>';
                                html += '<td>';
                                html += '<input type="hidden" name="matiereIds[]" value="' + matiere.id + '">';
                                html += '<input type="number" class="form-control" name="notes[]" min="0" max="20" step="0.25" value="' + (matiere.note || '') + '">';
                                html += '</td>';
                                html += '</tr>';
                            });
                        } else {
                            html = '<tr><td colspan="2" class="text-center">Aucune matière suivie avec vous</td></tr>';
                        }
                        
                        $('#notesEtudiantTable').html(html);
                    },
                    error: function() {
                        $('#notesEtudiantTable').html('<tr><td colspan="2" class="text-center">Erreur lors du chargement des matières</td></tr>');
                    }
                });
            },
            error: function() {
                alert('Erreur lors du chargement des données de l\'étudiant');
            }
        });
    });
    
    // Absences d'un étudiant
    $('#absencesEtudiantModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        
        $('#absencesEtudiantId').val(id);
        
        // Initialiser la date d'absence à aujourd'hui
        document.getElementById('absenceDateAbsence').valueAsDate = new Date();
        
        // Appel AJAX pour obtenir les détails de l'étudiant et ses absences
        $.ajax({
            url: '${pageContext.request.contextPath}/api/etudiants/' + id,
            type: 'GET',
            success: function(etudiant) {
                $('#absencesEtudiantNomPrenom').text(etudiant.prenom + ' ' + etudiant.nom);
                
                // Récupérer les matières pour le sélecteur
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/enseignants/current/matieres',
                    type: 'GET',
                    success: function(matieres) {
                        var html = '<option value="">Sélectionner une matière...</option>';
                        
                        if (matieres && matieres.length > 0) {
                            matieres.forEach(function(matiere) {
                                html += '<option value="' + matiere.id + '">' + matiere.nom + ' (' + matiere.code + ')</option>';
                            });
                        }
                        
                        $('#absenceMatiereId').html(html);
                    }
                });
                
                // Récupérer les absences
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/enseignants/current/etudiants/' + id + '/absences',
                    type: 'GET',
                    success: function(absences) {
                        var html = '';
                        
                        if (absences && absences.length > 0) {
                            absences.forEach(function(absence) {
                                html += '<tr>';
                                html += '<td>' + new Date(absence.dateAbsence).toLocaleDateString() + '</td>';
                                html += '<td>' + absence.matiere.nom + ' (' + absence.matiere.code + ')</td>';
                                html += '<td>';
                                if (absence.justification) {
                                    html += '<span class="text-success"><i class="fas fa-check-circle me-1"></i>' + absence.justification + '</span>';
                                } else {
                                    html += '<span class="text-danger"><i class="fas fa-times-circle me-1"></i>Non justifiée</span>';
                                }
                                html += '</td>';
                                html += '<td>';
                                html += '<div class="btn-group btn-group-sm" role="group">';
                                html += '<button type="button" class="btn btn-warning" onclick="modifierAbsenceEtudiant(' + absence.id + ')">';
                                html += '<i class="fas fa-edit"></i>';
                                html += '</button>';
                                html += '<button type="button" class="btn btn-danger" onclick="supprimerAbsenceEtudiant(' + absence.id + ')">';
                                html += '<i class="fas fa-trash-alt"></i>';
                                html += '</button>';
                                html += '</div>';
                                html += '</td>';
                                html += '</tr>';
                            });
                        } else {
                            html = '<tr><td colspan="4" class="text-center">Aucune absence enregistrée</td></tr>';
                        }
                        
                        $('#absencesEtudiantTable').html(html);
                    },
                    error: function() {
                        $('#absencesEtudiantTable').html('<tr><td colspan="4" class="text-center">Erreur lors du chargement des absences</td></tr>');
                    }
                });
            },
            error: function() {
                alert('Erreur lors du chargement des données de l\'étudiant');
            }
        });
    });
    
    // Afficher/masquer le formulaire d'ajout d'absence
    $('#ajouterAbsenceEtudiantBtn').click(function() {
        $('#formAjouterAbsenceEtudiant').slideDown();
    });
    
    $('#annulerAbsenceEtudiantBtn').click(function() {
        $('#formAjouterAbsenceEtudiant').slideUp();
    });
    
    // Modifier une absence d'étudiant
    function modifierAbsenceEtudiant(absenceId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/absences/' + absenceId,
            type: 'GET',
            success: function(absence) {
                // Créer un modal dynamiquement pour modifier l'absence
                var modalId = 'modifierAbsenceEtudiantModal' + absenceId;
                
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
                
                var etudiantInfo = $('<p></p>');
                etudiantInfo.append('<strong>Étudiant: </strong>' + absence.etudiant.prenom + ' ' + absence.etudiant.nom);
                modalBody.append(etudiantInfo);
                
                var matiereInfo = $('<p></p>');
                matiereInfo.append('<strong>Matière: </strong>' + absence.matiere.nom + ' (' + absence.matiere.code + ')');
                modalBody.append(matiereInfo);
                
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
    
    // Supprimer une absence d'étudiant
    function supprimerAbsenceEtudiant(absenceId) {
        if (confirm('Êtes-vous sûr de vouloir supprimer cette absence ?')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/EnseignantServlet',
                type: 'POST',
                data: {
                    action: 'supprimerAbsence',
                    absenceId: absenceId
                },
                success: function() {
                    // Rafraîchir la liste des absences
                    var etudiantId = $('#absencesEtudiantId').val();
                    $.ajax({
                        url: '${pageContext.request.contextPath}/api/enseignants/current/etudiants/' + etudiantId + '/absences',
                        type: 'GET',
                        success: function(absences) {
                            var html = '';
                            
                            if (absences && absences.length > 0) {
                                absences.forEach(function(absence) {
                                    html += '<tr>';
                                    html += '<td>' + new Date(absence.dateAbsence).toLocaleDateString() + '</td>';
                                    html += '<td>' + absence.matiere.nom + ' (' + absence.matiere.code + ')</td>';
                                    html += '<td>';
                                    if (absence.justification) {
                                        html += '<span class="text-success"><i class="fas fa-check-circle me-1"></i>' + absence.justification + '</span>';
                                    } else {
                                        html += '<span class="text-danger"><i class="fas fa-times-circle me-1"></i>Non justifiée</span>';
                                    }
                                    html += '</td>';
                                    html += '<td>';
                                    html += '<div class="btn-group btn-group-sm" role="group">';
                                    html += '<button type="button" class="btn btn-warning" onclick="modifierAbsenceEtudiant(' + absence.id + ')">';
                                    html += '<i class="fas fa-edit"></i>';
                                    html += '</button>';
                                    html += '<button type="button" class="btn btn-danger" onclick="supprimerAbsenceEtudiant(' + absence.id + ')">';
                                    html += '<i class="fas fa-trash-alt"></i>';
                                    html += '</button>';
                                    html += '</div>';
                                    html += '</td>';
                                    html += '</tr>';
                                });
                            } else {
                                html = '<tr><td colspan="4" class="text-center">Aucune absence enregistrée</td></tr>';
                            }
                            
                            $('#absencesEtudiantTable').html(html);
                        }
                    });
                },
                error: function() {
                    alert('Erreur lors de la suppression de l\'absence');
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
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />