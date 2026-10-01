import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:video_player/video_player.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/property.dart';
import '../providers/property_providers.dart';
import '../widgets/property_image.dart';
import '../widgets/property_price.dart';

class PropertyDetailsScreen extends ConsumerWidget {
  const PropertyDetailsScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProperty = ref.watch(propertyDetailsProvider(propertyId));

    return Scaffold(
      body: asyncProperty.when(
        loading: () => const AppLoader(),
        error: (error, _) => AppError(
          message: error is Failure
              ? error.message
              : 'Failed to load property.',
          onRetry: () => ref.invalidate(propertyDetailsProvider(propertyId)),
        ),
        data: (property) => _DetailsBody(property: property),
      ),
    );
  }
}

class _DetailsBody extends ConsumerWidget {
  const _DetailsBody({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isFavorite = ref.watch(favoriteIdsProvider).contains(property.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: property.photos.isNotEmpty
                  ? _PhotoGallery(photos: property.photos)
                  : Container(color: AppColors.outline),
            ),
            actions: [
              IconButton(
                icon: AppIcon(
                  HugeIcons.strokeRoundedFavourite,
                  color: isFavorite ? AppColors.error : null,
                ),
                onPressed: () {
                  ref.read(favoriteIdsProvider.notifier).toggle(property.id);
                  ref
                      .read(favoritePropertyProvider)
                      .call(property.id, !isFavorite);
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: theme.textTheme.headlineMedium,
                        ),
                      ),
                      if (property.isVerified)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSmall,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const AppIcon(
                                HugeIcons.strokeRoundedCheckmarkBadge01,
                                size: 14,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.verified,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    property.locationLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PropertyPrice(priceTzs: property.priceTzs),
                  if (property.type == PropertyType.residential) ...[
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        _SpecBadge(
                          icon: HugeIcons.strokeRoundedBed,
                          label: l10n.bedsCount(property.bedrooms),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _SpecBadge(
                          icon: HugeIcons.strokeRoundedBathtub01,
                          label: l10n.bathsCount(property.bathrooms),
                        ),
                        if (property.furnished) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _SpecBadge(
                            icon: HugeIcons.strokeRoundedDiningTable,
                            label: l10n.furnished,
                          ),
                        ],
                      ],
                    ),
                  ],
                  if (property.videoUrl != null &&
                      property.videoUrl!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.videoTour,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _VideoTour(
                      url: property.videoUrl!,
                      thumbnail: property.photos.isNotEmpty
                          ? property.photos.first
                          : null,
                    ),
                  ],
                  if (property.amenities.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: property.amenities
                          .map((a) => Chip(label: Text(a)))
                          .toList(),
                    ),
                  ],
                  if (property.description != null &&
                      property.description!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.description,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      property.description!,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppButton(
            label: l10n.revealContact,
            icon: HugeIcons.strokeRoundedCall,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.contactSubscribeNotice)),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PhotoGallery extends StatefulWidget {
  const _PhotoGallery({required this.photos});

  final List<String> photos;

  @override
  State<_PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<_PhotoGallery> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: widget.photos.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) =>
              PropertyImage(url: widget.photos[i]),
        ),
        if (widget.photos.length > 1)
          Positioned(
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Text(
                '${_index + 1} / ${widget.photos.length}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}

class _VideoTour extends StatefulWidget {
  const _VideoTour({required this.url, this.thumbnail});

  final String url;
  final String? thumbnail;

  @override
  State<_VideoTour> createState() => _VideoTourState();
}

class _VideoTourState extends State<_VideoTour> {
  late final VideoPlayerController _controller;
  bool _initialized = false;
  bool _initializing = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (!_initialized) {
      if (_initializing) return;
      setState(() => _initializing = true);
      try {
        await _controller.initialize();
        await _controller.play();
        if (mounted) {
          setState(() {
            _initialized = true;
            _initializing = false;
          });
        }
      } catch (_) {
        if (mounted) setState(() => _initializing = false);
      }
      return;
    }
    if (_controller.value.isPlaying) {
      await _controller.pause();
    } else {
      await _controller.play();
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_initialized)
              VideoPlayer(_controller)
            else if (widget.thumbnail != null)
              PropertyImage(url: widget.thumbnail!)
            else
              Container(color: AppColors.outline),
            if (!_initialized || !_controller.value.isPlaying)
              Center(
                child: _initializing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : IconButton.filled(
                        icon: AppIcon(
                          _initialized
                              ? HugeIcons.strokeRoundedPlay
                              : HugeIcons.strokeRoundedPlayCircle,
                          size: 40,
                        ),
                        onPressed: _toggle,
                      ),
              ),
            if (_initialized)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _toggle,
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: AppColors.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SpecBadge extends StatelessWidget {
  const _SpecBadge({required this.icon, required this.label});

  final HugeIconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon(icon, size: 18),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
