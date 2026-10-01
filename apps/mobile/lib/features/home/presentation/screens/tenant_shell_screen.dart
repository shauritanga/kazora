import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/widgets/app_icon.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../favorites/presentation/screens/favorites_screen.dart';
import '../../../messages/presentation/screens/messages_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../search/presentation/screens/search_screen.dart';
import 'home_screen.dart';

class TenantShellScreen extends StatefulWidget {
  const TenantShellScreen({super.key});

  @override
  State<TenantShellScreen> createState() => _TenantShellScreenState();
}

class _TenantShellScreenState extends State<TenantShellScreen> {
  int _index = 0;

  static const _tabs = [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const AppIcon(HugeIcons.strokeRoundedHome01),
            selectedIcon: const AppIcon(HugeIcons.strokeRoundedHome01),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const AppIcon(HugeIcons.strokeRoundedSearch01),
            selectedIcon: const AppIcon(HugeIcons.strokeRoundedSearch01),
            label: l10n.search,
          ),
          NavigationDestination(
            icon: const AppIcon(HugeIcons.strokeRoundedFavourite),
            selectedIcon: const AppIcon(HugeIcons.strokeRoundedFavourite),
            label: l10n.favorites,
          ),
          NavigationDestination(
            icon: const AppIcon(HugeIcons.strokeRoundedMessage01),
            selectedIcon: const AppIcon(HugeIcons.strokeRoundedMessage01),
            label: l10n.messages,
          ),
          NavigationDestination(
            icon: const AppIcon(HugeIcons.strokeRoundedUser),
            selectedIcon: const AppIcon(HugeIcons.strokeRoundedUser),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}
