<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Accueil - Gestion Académique</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome pour les icônes -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(rgba(13, 110, 253, 0.8), rgba(13, 110, 253, 0.9)), url('${pageContext.request.contextPath}/img/university-bg.jpg');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 100px 0;
            text-align: center;
            margin-bottom: 50px;
        }
        .hero-section h1 {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        .hero-section p {
            font-size: 1.25rem;
            max-width: 800px;
            margin: 0 auto 30px;
        }
        .feature-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
            height: 100%;
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }
        .feature-icon {
            font-size: 3rem;
            color: #0d6efd;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-university me-2"></i>Gestion Académique
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <c:choose>
                        <c:when test="${not empty sessionScope.email}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/${sessionScope.role}/dashboard.jsp">
                                    <i class="fas fa-tachometer-alt me-1"></i>Tableau de bord
                                </a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-user-circle me-1"></i>${sessionScope.email}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profil.jsp">
                                        <i class="fas fa-id-card me-1"></i>Mon profil
                                    </a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout.jsp">
                                        <i class="fas fa-sign-out-alt me-1"></i>Déconnexion
                                    </a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">
                                    <i class="fas fa-sign-in-alt me-1"></i>Connexion
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="hero-section">
        <div class="container">
            <h1>Système de Gestion de la Scolarité Universitaire</h1>
            <p>Une solution complète pour gérer les étudiants, les enseignants, les cours, les notes et les absences dans votre établissement.</p>
            <c:choose>
                <c:when test="${not empty sessionScope.email}">
                    <a href="${pageContext.request.contextPath}/${sessionScope.role}/dashboard.jsp" class="btn btn-light btn-lg">
                        <i class="fas fa-tachometer-alt me-2"></i>Accéder à mon tableau de bord
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-light btn-lg">
                        <i class="fas fa-sign-in-alt me-2"></i>Se connecter
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="container">
        <h2 class="text-center mb-5">Fonctionnalités principales</h2>
        
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card feature-card p-4">
                    <div class="card-body text-center">
                        <div class="feature-icon">
                            <i class="fas fa-user-graduate"></i>
                        </div>
                        <h4 class="card-title">Gestion des étudiants</h4>
                        <p class="card-text">Inscription, modification et consultation des informations des étudiants.</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card feature-card p-4">
                    <div class="card-body text-center">
                        <div class="feature-icon">
                            <i class="fas fa-chalkboard-teacher"></i>
                        </div>
                        <h4 class="card-title">Gestion des enseignants</h4>
                        <p class="card-text">Ajout, modification et attribution des enseignants aux matières.</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card feature-card p-4">
                    <div class="card-body text-center">
                        <div class="feature-icon">
                            <i class="fas fa-book"></i>
                        </div>
                        <h4 class="card-title">Gestion des matières</h4>
                        <p class="card-text">Création et modification des matières et attribution aux enseignants.</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card feature-card p-4">
                    <div class="card-body text-center">
                        <div class="feature-icon">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                        <h4 class="card-title">Gestion des notes</h4>
                        <p class="card-text">Ajout des notes, calcul des moyennes et génération des bulletins.</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card feature-card p-4">
                    <div class="card-body text-center">
                        <div class="feature-icon">
                            <i class="fas fa-calendar-times"></i>
                        </div>
                        <h4 class="card-title">Gestion des absences</h4>
                        <p class="card-text">Enregistrement et suivi des absences des étudiants.</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card feature-card p-4">
                    <div class="card-body text-center">
                        <div class="feature-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h4 class="card-title">Tableau de bord</h4>
                        <p class="card-text">Vue globale des statistiques et des informations importantes.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-dark text-light py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>Système de Gestion Académique</h5>
                    <p>Un projet Java EE développé dans le cadre du cours LPTI 3 DAR.</p>
                </div>
                <div class="col-md-3">
                    <h5>Liens utiles</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/" class="text-light">Accueil</a></li>
                        <li><a href="#" class="text-light">À propos</a></li>
                        <li><a href="#" class="text-light">Contact</a></li>
                    </ul>
                </div>
                <div class="col-md-3">
                    <h5>Contact</h5>
                    <address>
                        <p><i class="fas fa-map-marker-alt me-2"></i>ESMT, Dakar, Sénégal</p>
                        <p><i class="fas fa-envelope me-2"></i>info@esmt.sn</p>
                        <p><i class="fas fa-phone me-2"></i>+221 77 656 84 51</p>
                    </address>
                </div>
            </div>
            <hr>
            <div class="text-center">
                <p>&copy; <%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %> ESMT. Tous droits réservés.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>