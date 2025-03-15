<!-- src/main/webapp/admin/matieres.jsp -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Gestion des Matières" />
</jsp:include>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body d-flex justify-content-between align-items-center">
                <h3 class="card-title mb-0">
                    <i class="fas fa-book me-2"></i>Gestion des Matières
                </h3>
                <button type="button" class="btn btn-info text-white" data-bs-toggle="modal" data-bs-target="#ajouterMatiereModal">
                    <i class="fas fa-plus-circle me-1"></i>Ajouter une matière
                </button>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-8">
        <div class="card mb-4">
            <div class="card-header bg-light">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-list me-2"></i>Liste des matières
                        </h5>
                    </div>
                    <div class="col-md-6">
                        <input type="text" id="searchMatiere" class="form-control" placeholder="Rechercher une matière...">
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover" id="tableMatieres">
                        <thead>
                            <tr>
                                <th>Nom</th>
                                <th>Code</th>
                                <th>Coefficient</th>
                                <th>Enseignant</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="matiere" items="${matieres}">
                                <tr>
                                    <td>${matiere.nom}</td>
                                    <td>${matiere.code}</td>
                                    <td>${matiere.coefficient}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty matiere.enseignant}">
                                                ${matiere.enseignant.prenom} ${matiere.enseignant.nom}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Non assigné</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <button type="button" class="btn btn-primary" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#detailsMatiereModal" 
                                                    data-id="${matiere.id}">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button type="button" class="btn btn-warning" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#modifierMatiereModal" 
                                                    data-id="${matiere.id}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button type="button" class="btn btn-danger" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#supprimerMatiereModal" 
                                                    data-id="${matiere.id}">
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
    
    <div class="col-md-4">
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-chart-pie me-2"></i>Répartition des matières
                </h5>
            </div>
            <div class="card-body">
                <canvas id="matieresPieChart" width="100%" height="200"></canvas>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-info-circle me-2"></i>Informations
                </h5>
            </div>
            <div class="card-body">
                <p><strong>Total des matières:</strong> <span id="totalMatieres">${totalMatieres}</span></p>
                <p><strong>Matières avec enseignant:</strong> <span id="matieresAvecEnseignant">${matieresAvecEnseignant}</span></p>
                <p><strong>Matières sans enseignant:</strong> <span id="matieresSansEnseignant">${matieresSansEnseignant}</span></p>
                <p><strong>Coefficient moyen:</strong> <span id="coefficientMoyen">${coefficientMoyen}</span></p>
            </div>
        </div>
    </div>
</div>

<!-- Modal Ajouter Matière -->
<div class="modal fade" id="ajouterMatiereModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title">
                    <i class="fas fa-plus-circle me-2"></i>Ajouter une matière
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                <input type="hidden" name="action" value="ajouterMatiere">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="nomMatiereModal" class="form-label">Nom de la matière</label>
                        <input type="text" class="form-control" id="nomMatiereModal" name="nom" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="codeMatiereModal" class="form-label">Code</label>
                        <input type="text" class="form-control" id="codeMatiereModal" name="code" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="coefficientModal" class="form-label">Coefficient</label>
                        <input type="number" class="form-control" id="coefficientModal" name="coefficient" min="1" max="10" value="1" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="enseignantIdModal" class="form-label">Enseignant</label>
                        <select class="form-select" id="enseignantIdModal" name="enseignantId">
                            <option value="">Sélectionner un enseignant...</option>
                            <c:forEach var="enseignant" items="${enseignants}">
                                <option value="${enseignant.id}">${enseignant.prenom} ${enseignant.nom}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-info text-white">Ajouter</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Détails Matière -->
<div class="modal fade" id="detailsMatiereModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title">
                    <i class="fas fa-book me-2"></i>Détails de la matière
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h4 id="detailsMatiereNom"></h4>
                        <p class="mb-1"><strong>Code:</strong> <span id="detailsMatiereCode"></span></p>
                        <p class="mb-1"><strong>Coefficient:</strong> <span id="detailsMatiereCoefficient"></span></p>
                        <p class="mb-1"><strong>Enseignant:</strong> <span id="detailsMatiereEnseignant"></span></p>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Étudiants inscrits</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Matricule</th>
                                    <th>Nom</th>
                                    <th>Prénom</th>
                                    <th>Note</th>
                                </tr>
                            </thead>
                            <tbody id="detailsMatiereEtudiantsTable">
                                <!-- Étudiants insérés dynamiquement -->
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

<!-- Modal Modifier Matière -->
<div class="modal fade" id="modifierMatiereModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title">
                    <i class="fas fa-edit me-2"></i>Modifier la matière
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                <input type="hidden" name="action" value="modifierMatiere">
                <input type="hidden" name="id" id="modifierMatiereId">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="modifierMatiereNom" class="form-label">Nom de la matière</label>
                        <input type="text" class="form-control" id="modifierMatiereNom" name="nom" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="modifierMatiereCode" class="form-label">Code</label>
                        <input type="text" class="form-control" id="modifierMatiereCode" name="code" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="modifierMatiereCoefficient" class="form-label">Coefficient</label>
                        <input type="number" class="form-control" id="modifierMatiereCoefficient" name="coefficient" min="1" max="10" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="modifierMatiereEnseignantId" class="form-label">Enseignant</label>
                        <select class="form-select" id="modifierMatiereEnseignantId" name="enseignantId">
                            <option value="">Sélectionner un enseignant...</option>
                            <c:forEach var="enseignant" items="${enseignants}">
                                <option value="${enseignant.id}">${enseignant.prenom} ${enseignant.nom}</option>
                            </c:forEach>
                        </select>
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

<!-- Modal Supprimer Matière -->
<div class="modal fade" id="supprimerMatiereModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="fas fa-trash-alt me-2"></i>Supprimer la matière
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir supprimer cette matière ?</p>
                <p>Cette action est irréversible et supprimera également toutes les notes et inscriptions associées.</p>
                <p class="text-danger"><strong>Matière à supprimer: </strong><span id="supprimerMatiereNom"></span></p>
                <div id="supprimerMatiereEtudiantsWarning" class="alert alert-warning" style="display:none;">
                    <p><strong>Attention:</strong> Des étudiants sont inscrits à cette matière. Si vous la supprimez, toutes leurs notes pour cette matière seront également supprimées.</p>
                </div>
            </div>
            <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                <input type="hidden" name="action" value="supprimerMatiere">
                <input type="hidden" name="id" id="supprimerMatiereId">
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-danger">Confirmer la suppression</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Graphique en camembert pour la répartition des matières
    var ctx = document.getElementById('matieresPieChart').getContext('2d');
    var matieresPieChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Avec enseignant', 'Sans enseignant'],
            datasets: [{
                data: [${matieresAvecEnseignant}, ${matieresSansEnseignant}],
                backgroundColor: [
                    'rgba(40, 167, 69, 0.7)',
                    'rgba(220, 53, 69, 0.7)'
                ],
                borderColor: [
                    'rgba(40, 167, 69, 1)',
                    'rgba(220, 53, 69, 1)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });

    // Recherche de matières
    document.getElementById('searchMatiere').addEventListener('keyup', function() {
        var input = this.value.toLowerCase();
        var table = document.getElementById('tableMatieres');
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

    // Détails d'une matière
    $('#detailsMatiereModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        
        // Appel AJAX pour obtenir les détails de la matière
        $.ajax({
            url: '${pageContext.request.contextPath}/api/matieres/' + id,
            type: 'GET',
            success: function(matiere) {
                $('#detailsMatiereNom').text(matiere.nom);
                $('#detailsMatiereCode').text(matiere.code);
                $('#detailsMatiereCoefficient').text(matiere.coefficient);
                
                if (matiere.enseignant) {
                    $('#detailsMatiereEnseignant').text(matiere.enseignant.prenom + ' ' + matiere.enseignant.nom);
                } else {
                    $('#detailsMatiereEnseignant').html('<span class="text-muted">Non assigné</span>');
                }
                
                // Récupérer les étudiants inscrits
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/matieres/' + id + '/etudiants',
                    type: 'GET',
                    success: function(etudiants) {
                        var html = '';
                        
                        etudiants.forEach(function(etudiant) {
                            html += '<tr>';
                            html += '<td>' + etudiant.matricule + '</td>';
                            html += '<td>' + etudiant.nom + '</td>';
                            html += '<td>' + etudiant.prenom + '</td>';
                            html += '<td>' + (etudiant.note ? etudiant.note : '-') + '</td>';
                            html += '</tr>';
                        });
                        
                        if (etudiants.length === 0) {
                            html = '<tr><td colspan="4" class="text-center">Aucun étudiant inscrit</td></tr>';
                        }
                        
                        $('#detailsMatiereEtudiantsTable').html(html);
                    },
                    error: function() {
                        $('#detailsMatiereEtudiantsTable').html('<tr><td colspan="4" class="text-center">Erreur lors du chargement des étudiants</td></tr>');
                    }
                });
            },
            error: function() {
                alert('Erreur lors du chargement des données de la matière');
            }
        });
    });

    // Modifier une matière
    $('#modifierMatiereModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        
        // Appel AJAX pour obtenir les données de la matière
        $.ajax({
            url: '${pageContext.request.contextPath}/api/matieres/' + id,
            type: 'GET',
            success: function(matiere) {
                $('#modifierMatiereId').val(matiere.id);
                $('#modifierMatiereNom').val(matiere.nom);
                $('#modifierMatiereCode').val(matiere.code);
                $('#modifierMatiereCoefficient').val(matiere.coefficient);
                
                if (matiere.enseignant) {
                    $('#modifierMatiereEnseignantId').val(matiere.enseignant.id);
                } else {
                    $('#modifierMatiereEnseignantId').val('');
                }
            },
            error: function() {
                alert('Erreur lors du chargement des données de la matière');
                $('#modifierMatiereModal').modal('hide');
            }
        });
    });

    // Supprimer une matière
    $('#supprimerMatiereModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        
        // Appel AJAX pour obtenir le nom de la matière
        $.ajax({
            url: '${pageContext.request.contextPath}/api/matieres/' + id,
            type: 'GET',
            success: function(matiere) {
                $('#supprimerMatiereId').val(matiere.id);
                $('#supprimerMatiereNom').text(matiere.nom + ' (' + matiere.code + ')');
                
                // Vérifier s'il y a des étudiants inscrits
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/matieres/' + id + '/etudiants',
                    type: 'GET',
                    success: function(etudiants) {
                        if (etudiants.length > 0) {
                            $('#supprimerMatiereEtudiantsWarning').show();
                        } else {
                            $('#supprimerMatiereEtudiantsWarning').hide();
                        }
                    },
                    error: function() {
                        $('#supprimerMatiereEtudiantsWarning').hide();
                    }
                });
            },
            error: function() {
                alert('Erreur lors du chargement des données de la matière');
                $('#supprimerMatiereModal').modal('hide');
            }
        });
    });
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />