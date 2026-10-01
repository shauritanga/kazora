import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../properties/domain/entities/property.dart';
import '../../../../properties/presentation/providers/property_providers.dart';

class EditPropertyScreen extends ConsumerWidget {
  const EditPropertyScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProperty = ref.watch(propertyDetailsProvider(propertyId));

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Property')),
      body: asyncProperty.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text('Failed to load property.'),
          ),
        ),
        data: (property) => _EditForm(
          property: property,
          onSaved: () => context.go(RouteNames.landlordProperties),
        ),
      ),
    );
  }
}

class _EditForm extends ConsumerStatefulWidget {
  const _EditForm({required this.property, required this.onSaved});

  final Property property;
  final VoidCallback onSaved;

  @override
  ConsumerState<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends ConsumerState<_EditForm> {
  late final TextEditingController _titleController = TextEditingController(
    text: widget.property.title,
  );
  late final TextEditingController _priceController = TextEditingController(
    text: '${widget.property.priceTzs}',
  );
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    // API call will land here (PATCH /properties/:id)
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _saving = false);
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Price (TSh)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(widget.property.status.name),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: 'Save Changes', isLoading: _saving, onPressed: _save),
      ],
    );
  }
}
