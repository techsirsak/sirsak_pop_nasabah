import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_overlay.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class QrScanView extends ConsumerWidget {
  const QrScanView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(qrScanViewModelProvider);
    final viewModel = ref.read(qrScanViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    ref.listen(qrScanViewModelProvider, (previous, next) {
      if (next.scannedData != null && previous?.scannedData == null) {
        context.pop(next.scannedData);
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (state.hasPermission)
            MobileScanner(
              controller: viewModel.controller,
              onDetect: viewModel.onDetect,
              errorBuilder: (context, error, child) {
                return _buildErrorView(
                  context,
                  error.errorCode == MobileScannerErrorCode.permissionDenied
                      ? context.l10n.qrScanCameraPermission
                      : context.l10n.qrScanError,
                  colorScheme,
                  textTheme,
                );
              },
            )
          else
            _buildErrorView(
              context,
              context.l10n.qrScanCameraPermission,
              colorScheme,
              textTheme,
            ),

          // Scan overlay
          const QrScanOverlay(),

          // Top bar with close button and title
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Close button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const Spacer(),
                  // Title
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      context.l10n.qrScanTitle,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontVariations: AppFonts.semiBold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Placeholder for symmetry
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          // Instruction text below scan area
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.25,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
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
                      onPressed:
                          state.isFrontCamera ? null : viewModel.toggleTorch,
                      isActive: state.isTorchOn,
                      colorScheme: colorScheme,
                    ),
                    const Gap(48),
                    // Camera switch
                    _buildControlButton(
                      icon: Icons.cameraswitch_rounded,
                      onPressed: viewModel.switchCamera,
                      isActive: false,
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
            : Colors.white.withValues(alpha: 0.2),
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

  Widget _buildErrorView(
    BuildContext context,
    String message,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
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
            TextButton(
              onPressed: () => context.pop(),
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
