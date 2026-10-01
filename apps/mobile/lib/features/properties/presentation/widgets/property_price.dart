import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/extensions/string_extensions.dart';

class PropertyPrice extends StatelessWidget {
  const PropertyPrice({
    super.key,
    required this.priceTzs,
    this.isMonthly = true,
  });

  final int priceTzs;
  final bool isMonthly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        style: theme.textTheme.titleMedium?.copyWith(color: AppColors.primary),
        children: [
          TextSpan(text: priceTzs.toString().formatPrice()),
          if (isMonthly)
            TextSpan(
              text: ' /mo',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
        ],
      ),
    );
  }
}
