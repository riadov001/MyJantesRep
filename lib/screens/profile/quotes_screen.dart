import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/reservation_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_widget.dart';
import '../../config/theme.dart';
import '../../models/quote.dart';
import '../../utils/date_utils.dart' as app_date;

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuotes();
    });
  }

  void _loadQuotes() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isLoggedIn) {
      context.read<ReservationProvider>().loadQuotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Mes Devis'),
      body: Consumer2<ReservationProvider, AuthProvider>(
        builder: (context, reservationProvider, authProvider, child) {
          if (!authProvider.isLoggedIn) {
            return _buildNotLoggedIn();
          }

          if (reservationProvider.isLoading && reservationProvider.quotes.isEmpty) {
            return const LoadingWidget();
          }

          if (reservationProvider.error != null && reservationProvider.quotes.isEmpty) {
            return _buildErrorWidget(reservationProvider);
          }

          if (reservationProvider.quotes.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ReservationProvider>().loadQuotes();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reservationProvider.quotes.length,
              itemBuilder: (context, index) {
                final quote = reservationProvider.quotes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: _buildQuoteCard(quote),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/quote'),
        backgroundColor: AppTheme.primaryRed,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildQuoteCard(Quote quote) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(quote.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getServiceIcon(quote.service?.iconName ?? 'build'),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quote.service?.name ?? 'Service inconnu',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Devis #${quote.id}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(quote.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(quote.status).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    quote.statusText,
                    style: TextStyle(
                      color: _getStatusColor(quote.status),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.directions_car,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  quote.vehicleInfo,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.settings,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Taille: ${quote.wheelSize}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.description,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    quote.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (quote.estimatedPrice != null) ...[
              const SizedBox(height: 12),
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
                      Icons.euro,
                      color: AppTheme.primaryRed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Prix estimé: ${quote.estimatedPrice!.toInt()}€',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Demandé le ${app_date.AppDateUtils.formatDate(quote.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showQuoteDetails(quote),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Voir détails'),
                  ),
                ),
                if (quote.status == QuoteStatus.sent) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _acceptQuote(quote),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Accepter'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.request_quote_outlined,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun devis',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Vous n\'avez pas encore demandé de devis',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Demander un devis',
              icon: Icons.request_quote,
              onPressed: () => context.push('/quote'),
              isSecondary: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(ReservationProvider reservationProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              reservationProvider.error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Réessayer',
              icon: Icons.refresh,
              onPressed: () => reservationProvider.loadQuotes(),
              isSecondary: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotLoggedIn() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Connexion requise',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Vous devez être connecté pour voir vos devis',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Se connecter',
              icon: Icons.login,
              onPressed: () => context.push('/login'),
              isSecondary: false,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(QuoteStatus status) {
    switch (status) {
      case QuoteStatus.pending:
        return Colors.orange;
      case QuoteStatus.sent:
        return Colors.blue;
      case QuoteStatus.accepted:
        return Colors.green;
      case QuoteStatus.declined:
        return Colors.red;
    }
  }

  IconData _getServiceIcon(String iconName) {
    switch (iconName) {
      case 'build':
        return Icons.build;
      case 'palette':
        return Icons.palette;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'construction':
        return Icons.construction;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'water':
        return Icons.water;
      default:
        return Icons.build;
    }
  }

  void _showQuoteDetails(Quote quote) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Devis ${quote.service?.name ?? 'Détails'}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Statut', quote.statusText),
              _buildDetailRow('Véhicule', quote.vehicleInfo),
              _buildDetailRow('Taille des jantes', quote.wheelSize),
              _buildDetailRow('Description', quote.description),
              if (quote.estimatedPrice != null)
                _buildDetailRow('Prix estimé', '${quote.estimatedPrice!.toInt()}€'),
              if (quote.response != null && quote.response!.isNotEmpty)
                _buildDetailRow('Réponse', quote.response!),
              _buildDetailRow('Demandé le', app_date.AppDateUtils.formatDateTime(quote.createdAt)),
              if (quote.updatedAt != null)
                _buildDetailRow('Mis à jour le', app_date.AppDateUtils.formatDateTime(quote.updatedAt!)),
              if (quote.imageUrls.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Photos jointes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: quote.imageUrls.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.lightGray),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            quote.imageUrls[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.lightGray,
                                child: const Icon(Icons.error),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          if (quote.status == QuoteStatus.sent) ...[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _declineQuote(quote);
              },
              child: Text(
                'Décliner',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _acceptQuote(quote);
              },
              child: Text(
                'Accepter',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(value),
        ],
      ),
    );
  }

  Future<void> _acceptQuote(Quote quote) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accepter le devis'),
        content: Text(
          'Accepter le devis de ${quote.estimatedPrice?.toInt() ?? 0}€ ?\n\n'
          'En acceptant, vous confirmez votre intention de réserver ce service.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Accepter',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // TODO: Implement quote acceptance logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Devis accepté ! Nous vous contacterons bientôt.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _declineQuote(Quote quote) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Décliner le devis'),
        content: const Text('Êtes-vous sûr de vouloir décliner ce devis ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Décliner',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // TODO: Implement quote decline logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Devis décliné'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
