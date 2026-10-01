import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  static final _slides = [
    (
      HugeIcons.strokeRoundedRealEstate01,
      (AppLocalizations l10n) => l10n.onboardingVerifiedTitle,
      (AppLocalizations l10n) => l10n.onboardingVerifiedBody,
    ),
    (
      HugeIcons.strokeRoundedLink01,
      (AppLocalizations l10n) => l10n.onboardingConnectTitle,
      (AppLocalizations l10n) => l10n.onboardingConnectBody,
    ),
    (
      HugeIcons.strokeRoundedDiscoverCircle,
      (AppLocalizations l10n) => l10n.tagline,
      (AppLocalizations l10n) => l10n.onboardingBody,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  await LocalStorage.instance.setOnboardingDone(true);
                  if (context.mounted) {
                    context.go(RouteNames.roleSelection);
                  }
                },
                child: Text(l10n.skip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppIcon(
                            slide.$1,
                            size: 96,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            slide.$2(l10n),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            slide.$3(l10n),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: i == _page ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: i == _page ? AppColors.primary : AppColors.outline,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AppButton(
                label: _page == _slides.length - 1
                    ? l10n.getStarted
                    : l10n.next,
                onPressed: () async {
                  if (_page < _slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    await LocalStorage.instance.setOnboardingDone(true);
                    if (context.mounted) {
                      context.go(RouteNames.roleSelection);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
