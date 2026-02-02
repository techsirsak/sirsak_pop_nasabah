import 'package:flutter/material.dart';

class QrScanOverlay extends StatefulWidget {
  const QrScanOverlay({
    super.key,
    this.scanAreaSize = 280,
    this.borderColor,
    this.borderWidth = 4,
    this.cornerLength = 30,
    this.overlayColor,
  });

  final double scanAreaSize;
  final Color? borderColor;
  final double borderWidth;
  final double cornerLength;
  final Color? overlayColor;

  @override
  State<QrScanOverlay> createState() => _QrScanOverlayState();
}

class _QrScanOverlayState extends State<QrScanOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = widget.borderColor ?? colorScheme.primary;
    final overlayColor =
        widget.overlayColor ?? Colors.black.withValues(alpha: 0.6);

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _ScanOverlayPainter(
              scanAreaSize: widget.scanAreaSize,
              borderColor: borderColor.withValues(alpha: _animation.value),
              borderWidth: widget.borderWidth,
              cornerLength: widget.cornerLength,
              overlayColor: overlayColor,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  _ScanOverlayPainter({
    required this.scanAreaSize,
    required this.borderColor,
    required this.borderWidth,
    required this.cornerLength,
    required this.overlayColor,
  });

  final double scanAreaSize;
  final Color borderColor;
  final double borderWidth;
  final double cornerLength;
  final Color overlayColor;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final scanRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    // Draw semi-transparent overlay
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(scanRect, const Radius.circular(12)),
      )
      ..fillType = PathFillType.evenOdd;

    final overlayPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(overlayPath, overlayPaint);

    // Draw corner brackets
    final cornerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    final left = scanRect.left;
    final top = scanRect.top;
    final right = scanRect.right;
    final bottom = scanRect.bottom;

    // Top-left corner
    final topLeftPath = Path()
      ..moveTo(left, top + cornerLength)
      ..lineTo(left, top + 12)
      ..quadraticBezierTo(left, top, left + 12, top)
      ..lineTo(left + cornerLength, top);
    canvas.drawPath(topLeftPath, cornerPaint);

    // Top-right corner
    final topRightPath = Path()
      ..moveTo(right - cornerLength, top)
      ..lineTo(right - 12, top)
      ..quadraticBezierTo(right, top, right, top + 12)
      ..lineTo(right, top + cornerLength);
    canvas.drawPath(topRightPath, cornerPaint);

    // Bottom-left corner
    final bottomLeftPath = Path()
      ..moveTo(left, bottom - cornerLength)
      ..lineTo(left, bottom - 12)
      ..quadraticBezierTo(left, bottom, left + 12, bottom)
      ..lineTo(left + cornerLength, bottom);
    canvas.drawPath(bottomLeftPath, cornerPaint);

    // Bottom-right corner
    final bottomRightPath = Path()
      ..moveTo(right - cornerLength, bottom)
      ..lineTo(right - 12, bottom)
      ..quadraticBezierTo(right, bottom, right, bottom - 12)
      ..lineTo(right, bottom - cornerLength);
    canvas.drawPath(bottomRightPath, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant _ScanOverlayPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.scanAreaSize != scanAreaSize ||
        oldDelegate.borderWidth != borderWidth;
  }
}
