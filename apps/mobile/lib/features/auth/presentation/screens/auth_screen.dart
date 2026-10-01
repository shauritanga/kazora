import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/user_role.dart';
import '../providers/auth_providers.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;
  Timer? _otpTimer;
  int _secondsRemaining = 0;

  static const _otpTtlSeconds = 300;

  @override
  void dispose() {
    _otpTimer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _otpTimer?.cancel();
    setState(() => _secondsRemaining = _otpTtlSeconds);
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
      } else {
        setState(() => _secondsRemaining -= 1);
      }
    });
  }

  String _formatRemaining() {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool _isValidPhone(String phone) {
    final normalized = phone.replaceAll(RegExp(r'[\s-]'), '');
    return RegExp(r'^\+?\d{9,15}$').hasMatch(normalized);
  }

  Future<void> _sendOtp() async {
    final l10n = AppLocalizations.of(context);
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      context.showSnackBar(l10n.phoneRequired, isError: true);
      return;
    }
    if (!_isValidPhone(phone)) {
      context.showSnackBar(l10n.phoneInvalid, isError: true);
      return;
    }
    final ok = await ref.read(sessionProvider.notifier).requestOtp(phone);
    if (ok && mounted) {
      setState(() => _otpSent = true);
      _startCountdown();
    }
  }

  Future<void> _resendOtp() async {
    final l10n = AppLocalizations.of(context);
    final phone = _phoneController.text.trim();
    final ok = await ref.read(sessionProvider.notifier).requestOtp(phone);
    if (ok && mounted) {
      _startCountdown();
      context.showSnackBar(l10n.codeResent);
    }
  }

  Future<void> _verifyOtp() async {
    final l10n = AppLocalizations.of(context);
    final phone = _phoneController.text.trim();
    final code = _otpController.text.trim();
    if (code.isEmpty) {
      context.showSnackBar(l10n.otpRequired, isError: true);
      return;
    }
    final role = UserRole.fromString(LocalStorage.instance.role);
    final ok = await ref.read(sessionProvider.notifier).verifyOtp(
      phone,
      code,
      role,
    );
    if (ok && mounted) context.go(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);

    ref.listen(sessionProvider, (previous, next) {
      final failure = next.failure;
      if (failure != null && failure != previous?.failure) {
        context.showSnackBar(failure.message, isError: true);
      }
    });

    final isLoading = session.isRequestingOtp || session.isVerifying;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: l10n.back,
                  icon: const AppIcon(HugeIcons.strokeRoundedArrowLeft01),
                  onPressed: () => context.go(RouteNames.roleSelection),
                ),
              ),
              Text(l10n.login, style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.authSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                controller: _phoneController,
                label: l10n.phoneNumberLabel,
                hint: l10n.phoneNumberHint,
                icon: HugeIcons.strokeRoundedTelephone,
                keyboardType: TextInputType.phone,
                enabled: !_otpSent,
              ),
              if (_otpSent) ...[
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _otpController,
                  label: l10n.otpLabel,
                  hint: l10n.otpHint,
                  icon: HugeIcons.strokeRoundedLock,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _verifyOtp(),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _secondsRemaining > 0
                      ? l10n.otpExpiresIn(_formatRemaining())
                      : l10n.otpExpired,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _secondsRemaining > 0
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
                        : theme.colorScheme.error,
                  ),
                ),
              ],
              const Spacer(),
              AppButton(
                label: _otpSent ? l10n.verifyContinue : l10n.sendCode,
                isLoading: isLoading,
                onPressed: _otpSent ? _verifyOtp : _sendOtp,
              ),
              if (_otpSent) ...[
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: TextButton(
                    onPressed: isLoading ? null : _resendOtp,
                    child: Text(l10n.resendCode),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
