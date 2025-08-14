import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showProfileButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.showProfileButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return AppBar(
          title: Text(title),
          leading: showBackButton && context.canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                )
              : null,
          actions: [
            if (actions != null) ...actions!,
            if (showProfileButton)
              PopupMenuButton<String>(
                icon: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.primaryRed,
                  child: authProvider.isLoggedIn
                      ? Text(
                          authProvider.user!.firstName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
                onSelected: (String value) {
                  switch (value) {
                    case 'profile':
                      context.push('/profile');
                      break;
                    case 'reservations':
                      context.push('/reservations');
                      break;
                    case 'quotes':
                      context.push('/quotes-history');
                      break;
                    case 'login':
                      context.push('/login');
                      break;
                    case 'register':
                      context.push('/register');
                      break;
                    case 'logout':
                      _showLogoutDialog(context, authProvider);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  if (authProvider.isLoggedIn) {
                    return [
                      PopupMenuItem<String>(
                        value: 'profile',
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Mon profil'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'reservations',
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text('Mes réservations'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'quotes',
                        child: ListTile(
                          leading: const Icon(Icons.request_quote),
                          title: const Text('Mes devis'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: ListTile(
                          leading: const Icon(Icons.logout, color: AppTheme.primaryRed),
                          title: const Text('Déconnexion', style: TextStyle(color: AppTheme.primaryRed)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ];
                  } else {
                    return [
                      PopupMenuItem<String>(
                        value: 'login',
                        child: ListTile(
                          leading: const Icon(Icons.login),
                          title: const Text('Se connecter'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'register',
                        child: ListTile(
                          leading: const Icon(Icons.person_add),
                          title: const Text('S\'inscrire'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ];
                  }
                },
              ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await authProvider.logout();
              if (context.mounted) {
                context.go('/home');
              }
            },
            child: Text(
              'Déconnexion',
              style: TextStyle(color: AppTheme.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
