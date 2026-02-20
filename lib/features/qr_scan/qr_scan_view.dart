import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_overlay.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_state.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/app_dialog.dart';

class QrScanView extends ConsumerStatefulWidget {
  const QrScanView({super.key, this.deeplinkData});

  /// Optional deeplink data passed from router when app is opened via deeplink
  final String? deeplinkData;

  @override
  ConsumerState<QrScanView> createState() => _QrScanViewState();
}

class _QrScanViewState extends ConsumerState<QrScanView>
    with WidgetsBindingObserver {
  bool _deeplinkProcessed = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    ref
        .read(qrScanViewModelProvider.notifier)
        .handleAppLifecycleChange(
          appState,
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Process deeplink after first frame if data is provided
    if (widget.deeplinkData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_deeplinkProcessed) {
          _deeplinkProcessed = true;
          ref
              .read(qrScanViewModelProvider.notifier)
              .processDeeplink(widget.deeplinkData!);
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(qrScanViewModelProvider);
    final viewModel = ref.read(qrScanViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    ref.listen(qrScanViewModelProvider, (previous, next) {
      // Show error dialog when errorMessage is set
      if (next.errorMessage != null && previous?.errorMessage == null) {
        unawaited(
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) => const _QrFailedDialog(),
          ).then((_) {
            ref.read(qrScanViewModelProvider.notifier).dismissErrorAndRescan();
          }),
        );
      }

      // Start scanner when permission becomes granted
      // Use postFrameCallback to ensure MobileScanner widget is in the tree
      if (next.cameraPermissionStatus == CameraPermissionStatus.granted &&
          previous?.cameraPermissionStatus != CameraPermissionStatus.granted &&
          !next.isScannerReady) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(ref.read(qrScanViewModelProvider.notifier).startScanner());
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(
          context.l10n.qrScanTitle,
          style: textTheme.titleLarge?.copyWith(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Camera preview - render when permission granted
                // Scanner is started after widget is in tree via listener
                if (state.cameraPermissionStatus ==
                    CameraPermissionStatus.granted) ...[
                  MobileScanner(
                    controller: viewModel.controller,
                    onDetect: viewModel.onDetect,
                    errorBuilder: (context, error, child) {
                      // Ignore controllerAlreadyInitialized - not a real error
                      if (error.errorCode ==
                          MobileScannerErrorCode.controllerAlreadyInitialized) {
                        return const SizedBox.shrink();
                      }
                      final isPermissionError =
                          error.errorCode ==
                          MobileScannerErrorCode.permissionDenied;
                      return _QRErrorVIew(
                        message: isPermissionError
                            ? context.l10n.qrScanCameraPermission
                            : context.l10n.qrScanDecryptionFailed,
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
                  _QRErrorVIew(
                    message: context.l10n.qrScanPermissionDeniedForever,
                    showOpenSettings: true,
                  )
                else
                  _QRErrorVIew(
                    message: context.l10n.qrScanCameraPermission,
                  ),

                if (state.cameraPermissionStatus !=
                    CameraPermissionStatus.deniedForever) ...[
                  const QrScanOverlay(),

                  // Instruction text below scan area
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
                          context.l10n.qrScanInstruction,
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

                // Scan overlay
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
                    // Torch toggle
                    _buildControlButton(
                      icon: state.isTorchOn
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      onPressed: viewModel.toggleTorch,
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

class _QrFailedDialog extends StatelessWidget {
  const _QrFailedDialog();

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      maxWidth: 400,
      dialogTitle: context.l10n.qrScanTitle,
      dialogBody: Column(
        children: [
          Icon(
            PhosphorIcons.warning(),
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const Gap(12),
          Text(
            context.l10n.qrScanDecryptionFailed,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      dialogFooter: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.close),
        ),
      ),
    );
  }
}

class _QRErrorVIew extends ConsumerWidget {
  const _QRErrorVIew({
    required this.message,
    this.showOpenSettings = false,
  });

  final String message;
  final bool showOpenSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  unawaited(
                    ref
                        .read(qrScanViewModelProvider.notifier)
                        .openCameraSettings(),
                  );
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
              )
            else
              TextButton(
                onPressed: () {
                  ref.read(qrScanViewModelProvider.notifier).resetScan();
                },
                child: Text(
                  context.l10n.cancel,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.primary,
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
