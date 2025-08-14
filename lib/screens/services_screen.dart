import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/services_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/service_card.dart';
import '../widgets/loading_widget.dart';
import '../config/theme.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _searchQuery = '';
  String _sortBy = 'name'; // name, price, duration
  bool _showPopularOnly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicesProvider>().loadServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Nos Services',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Consumer<ServicesProvider>(
        builder: (context, servicesProvider, child) {
          if (servicesProvider.isLoading && servicesProvider.services.isEmpty) {
            return const LoadingWidget();
          }

          if (servicesProvider.error != null && servicesProvider.services.isEmpty) {
            return _buildErrorWidget(servicesProvider);
          }

          final filteredServices = _getFilteredServices(servicesProvider.services);

          return Column(
            children: [
              _buildSearchBar(),
              _buildServiceStats(filteredServices),
              Expanded(
                child: filteredServices.isEmpty
                    ? _buildEmptyWidget()
                    : _buildServicesList(filteredServices),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Rechercher un service...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildServiceStats(List services) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            '${services.length} service${services.length > 1 ? 's' : ''}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const Spacer(),
          if (_showPopularOnly)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Populaires',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServicesList(List services) {
    return RefreshIndicator(
      onRefresh: () => context.read<ServicesProvider>().loadServices(forceRefresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: ServiceCard(
              service: service,
              onTap: () => context.push('/service/${service.id}'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(ServicesProvider servicesProvider) {
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
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              servicesProvider.error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => servicesProvider.loadServices(forceRefresh: true),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun service trouvé',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Essayez de modifier vos critères de recherche',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List _getFilteredServices(List services) {
    var filtered = services.where((service) {
      final matchesSearch = _searchQuery.isEmpty ||
          service.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesPopular = !_showPopularOnly || service.isPopular;
      
      return matchesSearch && matchesPopular;
    }).toList();

    // Sort services
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'price':
          return a.price.compareTo(b.price);
        case 'duration':
          return a.duration.compareTo(b.duration);
        case 'name':
        default:
          return a.name.compareTo(b.name);
      }
    });

    return filtered;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtres et tri'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tri par :',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              RadioListTile<String>(
                title: const Text('Nom'),
                value: 'name',
                groupValue: _sortBy,
                onChanged: (value) => setState(() => _sortBy = value!),
              ),
              RadioListTile<String>(
                title: const Text('Prix'),
                value: 'price',
                groupValue: _sortBy,
                onChanged: (value) => setState(() => _sortBy = value!),
              ),
              RadioListTile<String>(
                title: const Text('Durée'),
                value: 'duration',
                groupValue: _sortBy,
                onChanged: (value) => setState(() => _sortBy = value!),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Services populaires uniquement'),
                value: _showPopularOnly,
                onChanged: (value) => setState(() => _showPopularOnly = value!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              this.setState(() {}); // Refresh the main screen
            },
            child: const Text('Appliquer'),
          ),
        ],
      ),
    );
  }
}
