import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/services_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/service_card.dart';
import '../widgets/custom_button.dart';
import '../config/theme.dart';
import '../config/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load services if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicesProvider>().loadServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'MyJantes Manager',
        showBackButton: false,
      ),
      body: Consumer2<AuthProvider, ServicesProvider>(
        builder: (context, authProvider, servicesProvider, child) {
          return RefreshIndicator(
            onRefresh: () => servicesProvider.loadServices(forceRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(authProvider),
                  const SizedBox(height: 24),
                  _buildHeroSection(),
                  const SizedBox(height: 32),
                  _buildServicesSection(servicesProvider),
                  const SizedBox(height: 32),
                  _buildQuickActionsSection(authProvider),
                  const SizedBox(height: 32),
                  _buildProcessSection(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/quote'),
        backgroundColor: AppTheme.primaryRed,
        child: const Icon(Icons.request_quote, color: Colors.white),
      ),
    );
  }

  Widget _buildWelcomeSection(AuthProvider authProvider) {
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authProvider.isLoggedIn 
                      ? 'Bonjour ${authProvider.user?.firstName ?? 'Utilisateur'} !'
                      : 'Bienvenue sur MyJantes',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Redonnez vie à vos jantes automobiles avec nos services professionnels',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1607228531191-b931a086cdea'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Services professionnels',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rénovation • Personnalisation • Réparation',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection(ServicesProvider servicesProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nos Services',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/services'),
              child: Text(
                'Voir tout',
                style: TextStyle(color: AppTheme.primaryRed),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (servicesProvider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (servicesProvider.error != null)
          Center(
            child: Column(
              children: [
                Text(
                  'Erreur de chargement',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => servicesProvider.loadServices(forceRefresh: true),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 16),
              itemCount: servicesProvider.services.length > 3 
                  ? 3 
                  : servicesProvider.services.length,
              itemBuilder: (context, index) {
                final service = servicesProvider.services[index];
                return Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 16),
                  child: ServiceCard(
                    service: service,
                    onTap: () => context.push('/service/${service.id}'),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildQuickActionsSection(AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions Rapides',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Demander un Devis',
                icon: Icons.request_quote,
                onPressed: () => context.push('/quote'),
                isSecondary: false,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: authProvider.isLoggedIn ? 'Mes Réservations' : 'Se Connecter',
                icon: authProvider.isLoggedIn ? Icons.calendar_today : Icons.login,
                onPressed: () => context.push(
                  authProvider.isLoggedIn ? '/reservations' : '/login'
                ),
                isSecondary: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProcessSection() {
    final steps = [
      {
        'icon': Icons.assessment,
        'title': 'Diagnostic',
        'description': 'Évaluation complète de l\'état de vos jantes',
      },
      {
        'icon': Icons.build,
        'title': 'Préparation',
        'description': 'Nettoyage et préparation de la surface',
      },
      {
        'icon': Icons.auto_fix_high,
        'title': 'Traitement',
        'description': 'Application du service choisi avec expertise',
      },
      {
        'icon': Icons.verified,
        'title': 'Contrôle',
        'description': 'Vérification qualité et finition parfaite',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notre Processus Qualité',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Chaque étape est réalisée avec le plus grand soin par nos experts',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        ...steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title']! as String,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step['description']! as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              Text(
                'Prêt à redonner vie à vos jantes ?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Contactez-nous',
                icon: Icons.phone,
                onPressed: () {
                  // Open phone dialer or contact screen
                },
                isSecondary: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
