import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';

class PropertyImage extends StatelessWidget {
  const PropertyImage({super.key, required this.url, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        placeholder: (context, url) => Container(
          color: AppColors.outline,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.outline,
          child: const AppIcon(
            HugeIcons.strokeRoundedImageNotFound01,
            size: 32,
          ),
        ),
      ),
    );
  }
}
