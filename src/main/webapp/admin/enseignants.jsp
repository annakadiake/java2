<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Gestion des Enseignants" />
</jsp:include>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body d-flex justify-content-between align-items-center">
                <h3 class="card-title mb-0">
                    <i class="fas fa-chalkboard-teacher me-2"></i>Gestion des Enseignants
                </h3>
                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#ajouterEnseignantModal">
                    <i class="fas fa-plus-circle me-1"></i>Ajouter un enseignant
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
                            <i class="fas fa-list me-2"></i>Liste des enseignants
                        </h5>
                    </div>
                    <div class="col-md-6">
                        <input type="text" id="searchEnseignant" class="form-control" placeholder="Rechercher un enseignant...">
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover" id="tableEnseignants">
                        <thead>
                            <tr>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Email</th>
                                <th>Spécialité</th>
                                
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="enseignant" items="${enseignants}">
                                <tr>
                                    <td>${enseignant.nom}</td>
                                    <td>${enseignant.prenom}</td>
                                    <td>${enseignant.email}</td>
                                    <td>${enseignant.specialite}</td>
                                    
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <button type="button" class="btn btn-primary" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#detailsEnseignantModal" 
                                                    data-id="${enseignant.id}">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button type="button" class="btn btn-warning" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#modifierEnseignantModal" 
                                                    data-id="${enseignant.id}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button type="button" class="btn btn-danger" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#supprimerEnseignantModal" 
                                                    data-id="${enseignant.id}">
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

<!-- Modal Ajouter Enseignant -->
<div class="modal fade" id="ajouterEnseignantModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title">
                    <i class="fas fa-plus-circle me-2"></i>Ajouter un enseignant
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                <input type="hidden" name="action" value="ajouterEnseignant">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="nomEnseignantModal" class="form-label">Nom</label>
                            <input type="text" class="form-control" id="nomEnseignantModal" name="nom" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="prenomEnseignantModal" class="form-label">Prénom</label>
                            <input type="text" class="form-control" id="prenomEnseignantModal" name="prenom" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="emailEnseignantModal" class="form-label">Email</label>
                        <input type="email" class="form-control" id="emailEnseignantModal" name="email" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="specialiteModal" class="form-label">Spécialité</label>
                        <input type="text" class="form-control" id="specialiteModal" name="specialite" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-success">Ajouter</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Détails Enseignant -->
<div class="modal fade" id="detailsEnseignantModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title">
                    <i class="fas fa-chalkboard-teacher me-2"></i>Détails de l'enseignant
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h4 id="detailsEnseignantNomPrenom"></h4>
                        <p class="mb-1"><strong>Email:</strong> <span id="detailsEnseignantEmail"></span></p>
                        <p class="mb-1"><strong>Spécialité:</strong> <span id="detailsEnseignantSpecialite"></span></p>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Matières enseignées</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Nom</th>
                                    <th>Code</th>
                                    <th>Coefficient</th>
                                    <th>Nb. Étudiants</th>
                                </tr>
                            </thead>
                            <tbody id="detailsEnseignantMatieresTable">
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

<!-- Modal Modifier Enseignant -->
<div class="modal fade" id="modifierEnseignantModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title">
                    <i class="fas fa-edit me-2"></i>Modifier l'enseignant
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                <input type="hidden" name="action" value="modifierEnseignant">
                <input type="hidden" name="id" id="modifierEnseignantId">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="modifierEnseignantNom" class="form-label">Nom</label>
                            <input type="text" class="form-control" id="modifierEnseignantNom" name="nom" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="modifierEnseignantPrenom" class="form-label">Prénom</label>
                            <input type="text" class="form-control" id="modifierEnseignantPrenom" name="prenom" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="modifierEnseignantEmail" class="form-label">Email</label>
                        <input type="email" class="form-control" id="modifierEnseignantEmail" name="email" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="modifierEnseignantSpecialite" class="form-label">Spécialité</label>
                        <input type="text" class="form-control" id="modifierEnseignantSpecialite" name="specialite" required>
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

<!-- Modal Supprimer Enseignant -->
<div class="modal fade" id="supprimerEnseignantModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="fas fa-trash-alt me-2"></i>Supprimer l'enseignant
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir supprimer cet enseignant ?</p>
                <p>Cette action est irréversible.</p>
                <p class="text-danger"><strong>Enseignant à supprimer: </strong><span id="supprimerEnseignantNom"></span></p>
                <div id="supprimerEnseignantMatieresWarning" class="alert alert-warning" style="display:none;">
                    <p><strong>Attention:</strong> Cet enseignant est assigné à une ou plusieurs matières. Si vous le supprimez, ces matières n'auront plus d'enseignant assigné.</p>
                </div>
            </div>
            <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                <input type="hidden" name="action" value="supprimerEnseignant">
                <input type="hidden" name="id" id="supprimerEnseignantId">
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-danger">Confirmer la suppression</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Recherche d'enseignants
    document.getElementById('searchEnseignant').addEventListener('keyup', function() {
        var input = this.value.toLowerCase();
        var table = document.getElementById('tableEnseignants');
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

    // Détails d'un enseignant
    $('#detailsEnseignantModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        
        // Appel AJAX pour obtenir les détails de l'enseignant
        $.ajax({
            url: '${pageContext.request.contextPath}/api/enseignants/' + id,
            type: 'GET',
            success: function(enseignant) {
                $('#detailsEnseignantNomPrenom').text(enseignant.prenom + ' ' + enseignant.nom);
                $('#detailsEnseignantEmail').text(enseignant.email);
                $('#detailsEnseignantSpecialite').text(enseignant.specialite);
                
                // Récupérer les matières
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/matieres/enseignant/' + id,
                    type: 'GET',
                    success: function(matieres) {
                        var html = '';
                        
                        matieres.forEach(function(matiere) {
                            html += '<tr>';
                            html += '<td>' + matiere.nom + '</td>';
                            html += '<td>' + matiere.code + '</td>';
                            html += '<td>' + matiere.coefficient + '</td>';
                            html += '<td>' + (matiere.nbEtudiants !== undefined ? matiere.nbEtudiants : 'N/A') + '</td>';
                            html += '</tr>';
                        });
                        
                        if (matieres.length === 0) {
                            html = '<tr><td colspan="4" class="text-center">Aucune matière assignée</td></tr>';
                        }
                        
                        $('#detailsEnseignantMatieresTable').html(html);
                    },
                    error: function() {
                        $('#detailsEnseignantMatieresTable').html('<tr><td colspan="4" class="text-center">Erreur lors du chargement des matières</td></tr>');
                    }
                });
            },
            error: function() {
                alert('Erreur lors du chargement des données de l\'enseignant');
            }
        });
    });

    // Modifier un enseignant
    $('#modifierEnseignantModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        
        // Appel AJAX pour obtenir les données de l'enseignant
        $.ajax({
            url: '${pageContext.request.contextPath}/api/enseignants/' + id,
            type: 'GET',
            success: function(enseignant) {
                $('#modifierEnseignantId').val(enseignant.id);
                $('#modifierEnseignantNom').val(enseignant.nom);
                $('#modifierEnseignantPrenom').val(enseignant.prenom);
                $('#modifierEnseignantEmail').val(enseignant.email);
                $('#modifierEnseignantSpecialite').val(enseignant.specialite);
            },
            error: function() {
                alert('Erreur lors du chargement des données de l\'enseignant');
                $('#modifierEnseignantModal').modal('hide');
            }
        });
    });

    // Supprimer un enseignant
    $('#supprimerEnseignantModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        
        // Appel AJAX pour obtenir le nom de l'enseignant
        $.ajax({
            url: '${pageContext.request.contextPath}/api/enseignants/' + id,
            type: 'GET',
            success: function(enseignant) {
                $('#supprimerEnseignantId').val(enseignant.id);
                $('#supprimerEnseignantNom').text(enseignant.prenom + ' ' + enseignant.nom);
                
                // Vérifier si l'enseignant a des matières
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/matieres/enseignant/' + id,
                    type: 'GET',
                    success: function(matieres) {
                        if (matieres.length > 0) {
                            $('#supprimerEnseignantMatieresWarning').show();
                        } else {
                            $('#supprimerEnseignantMatieresWarning').hide();
                        }
                    },
                    error: function() {
                        $('#supprimerEnseignantMatieresWarning').hide();
                    }
                });
            },
            error: function() {
                alert('Erreur lors du chargement des données de l\'enseignant');
                $('#supprimerEnseignantModal').modal('hide');
            }
        });
    });
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />