import 'package:flutter/material.dart';
import '../../../core/constants.dart';

/// Placeholder widget for map display
class MapPlaceholder extends StatelessWidget {
  final double? height;
  final String? label;
  final List<MapMarker>? markers;

  const MapPlaceholder({
    super.key,
    this.height,
    this.label,
    this.markers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 200,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Grid pattern to simulate map
          CustomPaint(
            size: Size.infinite,
            painter: _GridPainter(),
          ),
          // Fake streets
          CustomPaint(
            size: Size.infinite,
            painter: _StreetPainter(),
          ),
          // Markers
          if (markers != null && markers!.isNotEmpty)
            ...markers!.map((marker) => Positioned(
                  left: marker.x,
                  top: marker.y,
                  child: _MarkerWidget(
                    color: marker.color,
                    label: marker.label,
                  ),
                )),
          // Center marker (if no specific markers)
          if (markers == null || markers!.isEmpty)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      label ?? 'Current Location',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Map overlay label
          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Map View',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapMarker {
  final double x;
  final double y;
  final Color color;
  final String? label;

  const MapMarker({
    required this.x,
    required this.y,
    required this.color,
    this.label,
  });
}

class _MarkerWidget extends StatelessWidget {
  final Color color;
  final String? label;

  const _MarkerWidget({required this.color, this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 16,
          ),
        ),
        if (label != null)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.05)
      ..strokeWidth = 1;

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StreetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Horizontal street
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      paint,
    );

    // Vertical street
    canvas.drawLine(
      Offset(size.width * 0.6, 0),
      Offset(size.width * 0.6, size.height),
      paint,
    );

    // Diagonal street
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.4, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
