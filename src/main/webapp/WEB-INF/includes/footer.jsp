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
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/scripts.js"></script>
</body>
</html>