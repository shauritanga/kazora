import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/config/app_config.dart';
import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/extensions/string_extensions.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_icon.dart';
import '../../../../../core/widgets/app_text_field.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _areaController = TextEditingController();
  final _districtController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _region = AppConstants.regions.first;
  String _category = AppConstants.residentialCategories.first;
  int _bedrooms = 1;
  bool _furnished = false;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _districtController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    // API call will land here (POST /properties)
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _submitting = false);
    context.go(RouteNames.landlordDashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Property')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppTextField(
              controller: _titleController,
              label: 'Title',
              hint: 'e.g. 2 Bedroom Apartment in Mbezi Beach',
              icon: HugeIcons.strokeRoundedHeading01,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _region,
                    decoration: const InputDecoration(
                      labelText: 'Region',
                      prefixIcon: AppIcon(
                        HugeIcons.strokeRoundedLocation01,
                      ),
                    ),
                    items: AppConstants.regions
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (v) => setState(() => _region = v ?? _region),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: AppIcon(HugeIcons.strokeRoundedGrid),
                    ),
                    items: AppConstants.residentialCategories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c.replaceAll('_', ' ').capitalizeFirst(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _category = v ?? _category),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _priceController,
                    label: 'Price (TSh)',
                    icon: HugeIcons.strokeRoundedWallet01,
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || int.tryParse(v) == null)
                        ? 'Valid price required'
                        : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppTextField(
                    controller: _areaController,
                    label: 'Area / Estate',
                    icon: HugeIcons.strokeRoundedCity01,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _districtController,
              label: 'District',
              icon: HugeIcons.strokeRoundedBuilding02,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _bedrooms,
                    decoration: const InputDecoration(
                      labelText: 'Bedrooms',
                      prefixIcon: AppIcon(HugeIcons.strokeRoundedBed),
                    ),
                    items: List.generate(6, (i) => i + 1)
                        .map(
                          (n) => DropdownMenuItem(value: n, child: Text('$n')),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _bedrooms = v ?? _bedrooms),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Furnished'),
                    value: _furnished,
                    onChanged: (v) => setState(() => _furnished = v ?? false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _descriptionController,
              label: 'Description',
              maxLines: 4,
              icon: HugeIcons.strokeRoundedFile01,
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              icon: const AppIcon(HugeIcons.strokeRoundedCamera01),
              label: const Text(
                'Add photos (max ${AppConfig.maxListingPhotos})',
              ),
              onPressed: () {},
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Publish Listing',
              isLoading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
