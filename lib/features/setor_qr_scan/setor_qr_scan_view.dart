import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_overlay.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_state.dart';
import 'package:sirsak_pop_nasabah/features/setor_qr_scan/setor_qr_scan_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/app_dialog.dart';

class SetorQrScanView extends ConsumerStatefulWidget {
  const SetorQrScanView({super.key});

  @override
  ConsumerState<SetorQrScanView> createState() => _SetorQrScanViewState();
}

class _SetorQrScanViewState extends ConsumerState<SetorQrScanView>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    ref
        .read(setorQrScanViewModelProvider.notifier)
        .handleAppLifecycleChange(appState);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(setorQrScanViewModelProvider);
    final viewModel = ref.read(setorQrScanViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    ref.listen(setorQrScanViewModelProvider, (previous, next) {
      // Show error dialog when errorMessage is set
      if (next.errorMessage != null && previous?.errorMessage == null) {
        unawaited(
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) => _SetorFailedDialog(
              errorKey: next.errorMessage!,
            ),
          ).then((_) {
            ref
                .read(setorQrScanViewModelProvider.notifier)
                .dismissErrorAndRescan();
          }),
        );
      }

      // Show success dialog
      if (next.isSuccess && !previous!.isSuccess) {
        unawaited(
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) => const _SetorSuccessDialog(),
          ).then((_) {
            ref
                .read(setorQrScanViewModelProvider.notifier)
                .dismissErrorAndRescan();
          }),
        );
      }

      // Start scanner when permission becomes granted
      if (next.cameraPermissionStatus == CameraPermissionStatus.granted &&
          previous?.cameraPermissionStatus != CameraPermissionStatus.granted &&
          !next.isScannerReady) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(
            ref.read(setorQrScanViewModelProvider.notifier).startScanner(),
          );
        });
      }
    });

    return ColoredBox(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Camera preview
                if (state.cameraPermissionStatus ==
                    CameraPermissionStatus.granted) ...[
                  MobileScanner(
                    controller: viewModel.controller,
                    onDetect: viewModel.onDetect,
                    errorBuilder: (context, error, child) {
                      if (error.errorCode ==
                          MobileScannerErrorCode.controllerAlreadyInitialized) {
                        return const SizedBox.shrink();
                      }
                      final isPermissionError = error.errorCode ==
                          MobileScannerErrorCode.permissionDenied;
                      return _SetorErrorView(
                        message: isPermissionError
                            ? context.l10n.qrScanCameraPermission
                            : context.l10n.qrScanDecryptionFailed,
                        viewModel: viewModel,
                      );
                    },
                  ),
                ] else if (state.cameraPermissionStatus ==
                    CameraPermissionStatus.unknown)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                else if (state.cameraPermissionStatus ==
                    CameraPermissionStatus.deniedForever)
                  _SetorErrorView(
                    message: context.l10n.qrScanPermissionDeniedForever,
                    showOpenSettings: true,
                    viewModel: viewModel,
                  )
                else
                  _SetorErrorView(
                    message: context.l10n.qrScanCameraPermission,
                    viewModel: viewModel,
                  ),

                // Scan overlay
                const QrScanOverlay(),

                // Submitting overlay
                if (state.isSubmitting)
                  ColoredBox(
                    color: Colors.black.withValues(alpha: 0.7),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(color: Colors.white),
                          const Gap(16),
                          Text(
                            context.l10n.setorQrScanSubmitting,
                            style: textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontVariations: AppFonts.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Instruction text below scan area
                if (!state.isSubmitting)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.of(context).size.height * 0.05,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          context.l10n.setorQrScanInstruction,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontVariations: AppFonts.medium,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Bottom controls
          ColoredBox(
            color: colorScheme.surface,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: state.isTorchOn
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      onPressed:
                          state.isSubmitting ? null : viewModel.toggleTorch,
                      isActive: state.isTorchOn,
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isActive,
    required ColorScheme colorScheme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primary
            : Colors.black.withValues(alpha: 0.8),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isActive ? colorScheme.onPrimary : Colors.white,
          size: 28,
        ),
        onPressed: onPressed,
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}

class _SetorFailedDialog extends StatelessWidget {
  const _SetorFailedDialog({required this.errorKey});

  final String errorKey;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final errorMessage = errorKey == 'setorQrScanErrorInvalidQr'
        ? l10n.setorQrScanErrorInvalidQr
        : l10n.setorQrScanErrorApi;

    return AppDialog(
      maxWidth: 400,
      dialogTitle: l10n.setorQrScanTitle,
      dialogBody: Column(
        children: [
          Icon(
            PhosphorIcons.warning(),
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const Gap(12),
          Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      dialogFooter: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.setorQrScanRetry),
        ),
      ),
    );
  }
}

class _SetorSuccessDialog extends StatelessWidget {
  const _SetorSuccessDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppDialog(
      maxWidth: 400,
      dialogTitle: l10n.setorQrScanTitle,
      dialogBody: Column(
        children: [
          Icon(
            PhosphorIcons.checkCircle(),
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const Gap(12),
          Text(
            l10n.setorQrScanSuccess,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontVariations: AppFonts.semiBold,
                ),
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Text(
            l10n.setorQrScanSuccessMessage,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      dialogFooter: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ),
    );
  }
}

class _SetorErrorView extends StatelessWidget {
  const _SetorErrorView({
    required this.message,
    required this.viewModel,
    this.showOpenSettings = false,
  });

  final String message;
  final bool showOpenSettings;
  final SetorQrScanViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            const Gap(16),
            Text(
              message,
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontVariations: AppFonts.medium,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(24),
            if (showOpenSettings)
              ElevatedButton(
                onPressed: () {
                  unawaited(viewModel.openCameraSettings());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: Text(
                  context.l10n.qrScanOpenSettings,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontVariations: AppFonts.semiBold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
