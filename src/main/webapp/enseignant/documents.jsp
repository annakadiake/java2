<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Gestion des Documents" />
</jsp:include>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body d-flex justify-content-between align-items-center">
                <h3 class="card-title mb-0">
                    <i class="fas fa-file-alt me-2"></i>Gestion des Documents
                </h3>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#ajouterDocumentModal">
                    <i class="fas fa-file-upload me-1"></i>Ajouter un document
                </button>
            </div>
        </div>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-3">
        <div class="card">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-filter me-2"></i>Filtrer
                </h5>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label for="matiereFilter" class="form-label">Matière</label>
                    <select id="matiereFilter" class="form-select">
                        <option value="">Toutes les matières</option>
                        <c:forEach var="matiere" items="${matieres}">
                            <option value="${matiere.id}">${matiere.nom} (${matiere.code})</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label for="typeFilter" class="form-label">Type de document</label>
                    <select id="typeFilter" class="form-select">
                        <option value="">Tous les types</option>
                        <option value="cours">Support de cours</option>
                        <option value="td">Travaux dirigés</option>
                        <option value="tp">Travaux pratiques</option>
                        <option value="examen">Examen</option>
                        <option value="autre">Autre</option>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label for="searchDocument" class="form-label">Rechercher</label>
                    <input type="text" id="searchDocument" class="form-control" placeholder="Titre, description...">
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-9">
        <div class="card">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="fas fa-list me-2"></i>Documents partagés
                </h5>
            </div>
            <div class="card-body">
                <div class="list-group" id="documentsListe">
                    <c:forEach var="document" items="${documents}">
                        <div class="list-group-item list-group-item-action" data-matiere="${document.matiere.id}" data-type="${document.type}">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">${document.titre}</h5>
                                <small><fmt:formatDate value="${document.dateAjout}" pattern="dd/MM/yyyy" /></small>
                            </div>
                            <p class="mb-1">${empty document.description ? 'Aucune description' : document.description}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <small>
                                    <span class="badge bg-primary">${document.matiere.nom}</span>
                                    <span class="badge bg-secondary">${document.type}</span>
                                    <span class="badge bg-info">${document.tailleFichier}</span>
                                </small>
                                <div class="btn-group btn-group-sm" role="group">
                                    <a href="${pageContext.request.contextPath}/EnseignantServlet?action=telechargerDocument&documentId=${document.id}" class="btn btn-primary">
                                        <i class="fas fa-download me-1"></i>Télécharger
                                    </a>
                                    <button type="button" class="btn btn-danger" onclick="confirmerSuppression(${document.id}, '${document.titre}')">
                                        <i class="fas fa-trash-alt me-1"></i>Supprimer
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty documents}">
                        <div class="list-group-item text-center">
                            <p class="mb-0">Aucun document disponible</p>
                        </div>
                    </c:if>
                </div>
            </div>
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
                        <label for="matiereDocument" class="form-label">Matière</label>
                        <select class="form-select" id="matiereDocument" name="matiereId" required>
                            <option value="">Sélectionner une matière...</option>
                            <c:forEach var="matiere" items="${matieres}">
                                <option value="${matiere.id}">${matiere.nom} (${matiere.code})</option>
                            </c:forEach>
                        </select>
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
                        <div class="form-text">Taille maximale : 20 Mo</div>
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
    // Filtrer par matière
    document.getElementById('matiereFilter').addEventListener('change', function() {
        appliquerFiltres();
    });
    
    // Filtrer par type
    document.getElementById('typeFilter').addEventListener('change', function() {
        appliquerFiltres();
    });
    
    // Rechercher un document
    document.getElementById('searchDocument').addEventListener('keyup', function() {
        appliquerFiltres();
    });
    
    // Appliquer tous les filtres
    function appliquerFiltres() {
        var matiereId = document.getElementById('matiereFilter').value;
        var type = document.getElementById('typeFilter').value;
        var searchText = document.getElementById('searchDocument').value.toLowerCase();
        
        var documents = document.getElementById('documentsListe').getElementsByClassName('list-group-item-action');
        
        for (var i = 0; i < documents.length; i++) {
            var document = documents[i];
            var documentMatiereId = document.getAttribute('data-matiere');
            var documentType = document.getAttribute('data-type');
            var documentTitle = document.querySelector('h5').textContent.toLowerCase();
            var documentDescription = document.querySelector('p').textContent.toLowerCase();
            
            var matiereMatch = matiereId === '' || documentMatiereId === matiereId;
            var typeMatch = type === '' || documentType === type;
            var textMatch = searchText === '' || 
                           documentTitle.indexOf(searchText) > -1 || 
                           documentDescription.indexOf(searchText) > -1;
            
            if (matiereMatch && typeMatch && textMatch) {
                document.style.display = '';
            } else {
                document.style.display = 'none';
            }
        }
    }
    
    // Confirmer la suppression d'un document
    function confirmerSuppression(documentId, titreDocument) {
        if (confirm('Êtes-vous sûr de vouloir supprimer le document "' + titreDocument + '" ?')) {
            window.location.href = '${pageContext.request.contextPath}/EnseignantServlet?action=supprimerDocument&documentId=' + documentId;
        }
    }
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />