import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../config/theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Politique de confidentialité'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildSection(
              context,
              '1. Collecte des données',
              'Nous collectons les données personnelles que vous nous fournissez lors de :\n'
              '• La création de votre compte (nom, prénom, email, téléphone)\n'
              '• Les réservations de services (informations véhicule, photos)\n'
              '• Les demandes de devis (description des besoins)\n'
              '• L\'utilisation de l\'application (données de navigation)',
            ),
            _buildSection(
              context,
              '2. Utilisation des données',
              'Vos données personnelles sont utilisées pour :\n'
              '• Gérer votre compte et vos réservations\n'
              '• Traiter vos demandes de devis\n'
              '• Vous contacter concernant nos services\n'
              '• Améliorer la qualité de nos prestations\n'
              '• Respecter nos obligations légales',
            ),
            _buildSection(
              context,
              '3. Base légale du traitement',
              'Le traitement de vos données repose sur :\n'
              '• Votre consentement explicite\n'
              '• L\'exécution du contrat de service\n'
              '• Nos intérêts légitimes\n'
              '• Le respect d\'obligations légales',
            ),
            _buildSection(
              context,
              '4. Partage des données',
              'Nous ne vendons, ne louons ni ne partageons vos données personnelles avec des tiers, sauf :\n'
              '• Avec votre consentement explicite\n'
              '• Pour l\'exécution de nos services (partenaires techniques)\n'
              '• En cas d\'obligation légale\n'
              '• Pour protéger nos droits et sécurité',
            ),
            _buildSection(
              context,
              '5. Sécurité des données',
              'Nous mettons en place des mesures techniques et organisationnelles appropriées pour protéger vos données :\n'
              '• Chiffrement des données sensibles\n'
              '• Accès restreint aux données\n'
              '• Surveillance des systèmes\n'
              '• Formation du personnel\n'
              '• Audits de sécurité réguliers',
            ),
            _buildSection(
              context,
              '6. Conservation des données',
              'Nous conservons vos données personnelles pendant la durée nécessaire aux finalités pour lesquelles elles ont été collectées :\n'
              '• Données de compte : pendant la durée de votre relation client\n'
              '• Données de facturation : 10 ans (obligation légale)\n'
              '• Données de navigation : 13 mois maximum',
            ),
            _buildSection(
              context,
              '7. Vos droits',
              'Conformément au RGPD, vous disposez des droits suivants :\n'
              '• Droit d\'accès à vos données\n'
              '• Droit de rectification\n'
              '• Droit d\'effacement\n'
              '• Droit à la limitation du traitement\n'
              '• Droit à la portabilité\n'
              '• Droit d\'opposition\n'
              '• Droit de retirer votre consentement',
            ),
            _buildSection(
              context,
              '8. Exercice de vos droits',
              'Pour exercer vos droits, contactez-nous à l\'adresse : contact@myjantes.fr\n\n'
              'Nous nous engageons à répondre dans un délai d\'un mois. '
              'Vous pouvez également saisir la CNIL en cas de réclamation.',
            ),
            _buildSection(
              context,
              '9. Cookies et technologies similaires',
              'Notre application utilise des technologies de suivi pour :\n'
              '• Améliorer les performances\n'
              '• Analyser l\'utilisation\n'
              '• Personnaliser l\'expérience\n\n'
              'Vous pouvez gérer ces préférences dans les paramètres de votre appareil.',
            ),
            _buildSection(
              context,
              '10. Transferts internationaux',
              'Vos données peuvent être transférées vers des pays tiers disposant d\'un niveau de protection adéquat ou dans le cadre de garanties appropriées (clauses contractuelles types).',
            ),
            _buildSection(
              context,
              '11. Mineurs',
              'Nos services ne sont pas destinés aux mineurs de moins de 16 ans. '
              'Nous ne collectons pas sciemment de données personnelles concernant les mineurs.',
            ),
            _buildSection(
              context,
              '12. Modifications',
              'Cette politique peut être modifiée pour refléter les changements dans nos pratiques ou la législation. '
              'Nous vous informerons de toute modification importante.',
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
            Icons.privacy_tip,
            size: 48,
            color: AppTheme.primaryRed,
          ),
          const SizedBox(height: 16),
          Text(
            'Politique de confidentialité',
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
            'MyJantes s\'engage à protéger votre vie privée et vos données personnelles',
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
            'Délégué à la protection des données',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pour toute question relative à la protection de vos données :',
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
                'dpo@myjantes.fr',
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.primaryRed.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  color: AppTheme.primaryRed,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Vous pouvez également saisir la CNIL (www.cnil.fr) en cas de réclamation',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
