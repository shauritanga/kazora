import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_icon.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = LocalStorage.instance.role;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Center(
            child: const CircleAvatar(
              radius: 40,
              child: AppIcon(HugeIcons.strokeRoundedUser, size: 40),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              role == 'landlord' ? 'Landlord' : 'Renter',
              style: theme.textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ListTile(
            leading: const AppIcon(HugeIcons.strokeRoundedGlobe),
            title: const Text('Language'),
            subtitle: const Text('Kiswahili / English'),
          ),
          ListTile(
            leading: const AppIcon(HugeIcons.strokeRoundedChatting01),
            title: const Text('Help & Support'),
          ),
          const Divider(height: AppSpacing.xl),
          AppButton(
            label: 'Log out',
            isSecondary: true,
            icon: HugeIcons.strokeRoundedLogout01,
            onPressed: () async {
              await LocalStorage.instance.clearAccessToken();
              if (context.mounted) {
                context.go(RouteNames.onboarding);
              }
            },
          ),
        ],
      ),
    );
  }
}
