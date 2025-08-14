import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../config/theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Conditions d\'utilisation'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildSection(
              context,
              '1. Objet',
              'Les présentes conditions générales d\'utilisation (CGU) régissent l\'utilisation de l\'application mobile MyJantes Manager et des services associés proposés par MyJantes.',
            ),
            _buildSection(
              context,
              '2. Acceptation des conditions',
              'L\'utilisation de l\'application implique l\'acceptation pleine et entière des présentes CGU. Si vous n\'acceptez pas ces conditions, veuillez ne pas utiliser l\'application.',
            ),
            _buildSection(
              context,
              '3. Services proposés',
              'MyJantes Manager permet aux utilisateurs de :\n'
              '• Consulter les services de rénovation de jantes\n'
              '• Effectuer des réservations en ligne\n'
              '• Demander des devis personnalisés\n'
              '• Gérer leur compte et suivre leurs demandes\n'
              '• Accéder aux informations sur nos prestations',
            ),
            _buildSection(
              context,
              '4. Inscription et compte utilisateur',
              'Pour accéder à certaines fonctionnalités, vous devez créer un compte en fournissant des informations exactes et à jour. Vous êtes responsable de la confidentialité de vos identifiants de connexion.',
            ),
            _buildSection(
              context,
              '5. Réservations et paiements',
              'Les réservations effectuées via l\'application sont soumises à confirmation. Les prix affichés sont susceptibles de modifications. Le paiement s\'effectue selon les modalités convenues lors de la confirmation de la réservation.',
            ),
            _buildSection(
              context,
              '6. Annulation et modification',
              'Les demandes d\'annulation ou de modification doivent être effectuées dans les délais prévus. Des frais peuvent s\'appliquer selon les conditions spécifiques de chaque service.',
            ),
            _buildSection(
              context,
              '7. Responsabilités',
              'MyJantes s\'engage à fournir des services de qualité. Cependant, la responsabilité de la société est limitée aux dommages directs prouvés. L\'utilisateur est responsable de l\'exactitude des informations fournies.',
            ),
            _buildSection(
              context,
              '8. Propriété intellectuelle',
              'Tous les éléments de l\'application (textes, images, logos, etc.) sont protégés par le droit de la propriété intellectuelle. Toute reproduction non autorisée est interdite.',
            ),
            _buildSection(
              context,
              '9. Protection des données',
              'Le traitement de vos données personnelles est régi par notre politique de confidentialité, accessible dans l\'application.',
            ),
            _buildSection(
              context,
              '10. Modification des CGU',
              'MyJantes se réserve le droit de modifier les présentes CGU à tout moment. Les utilisateurs seront informés des modifications importantes.',
            ),
            _buildSection(
              context,
              '11. Droit applicable',
              'Les présentes CGU sont soumises au droit français. Tout litige sera porté devant les tribunaux compétents.',
            ),
            const SizedBox(height: 32),
            _buildContact(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryRed.withOpacity(0.1),
            AppTheme.darkGray,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryRed.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.description,
            size: 48,
            color: AppTheme.primaryRed,
          ),
          const SizedBox(height: 16),
          Text(
            'Conditions d\'utilisation',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Version du 1er janvier 2024',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Veuillez lire attentivement ces conditions avant d\'utiliser nos services',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryRed,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContact(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pour toute question concernant ces conditions d\'utilisation, contactez-nous :',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.email,
                size: 16,
                color: AppTheme.primaryRed,
              ),
              const SizedBox(width: 8),
              Text(
                'contact@myjantes.fr',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.phone,
                size: 16,
                color: AppTheme.primaryRed,
              ),
              const SizedBox(width: 8),
              Text(
                '+33 1 23 45 67 89',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: AppTheme.primaryRed,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '123 Rue de la Rénovation\n75000 Paris, France',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryRed,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
