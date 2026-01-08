import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants.dart';
import '../../../models/complaint_model.dart';

/// Real Google Maps widget with heatmap visualization
class NearbyMapWidget extends StatefulWidget {
  final List<ComplaintModel> complaints;
  final Function(ComplaintModel)? onMarkerTapped;

  const NearbyMapWidget({
    super.key,
    required this.complaints,
    this.onMarkerTapped,
  });

  @override
  State<NearbyMapWidget> createState() => _NearbyMapWidgetState();
}

class _NearbyMapWidgetState extends State<NearbyMapWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Circle> _heatmapCircles = {};
  Set<Marker> _markers = {};

  // Center on Ahmedabad, India (default location)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.0225, 72.5714),
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    _buildHeatmapAndMarkers();
  }

  @override
  void didUpdateWidget(NearbyMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.complaints != widget.complaints) {
      _buildHeatmapAndMarkers();
    }
  }

  void _buildHeatmapAndMarkers() {
    final circles = <Circle>{};
    final markers = <Marker>{};

    for (int i = 0; i < widget.complaints.length; i++) {
      final complaint = widget.complaints[i];
      final position = LatLng(complaint.latitude, complaint.longitude);
      final color = _getSeverityColor(complaint.severity);

      // Add heatmap circle (larger, semi-transparent)
      circles.add(
        Circle(
          circleId: CircleId('heatmap_${complaint.id}'),
          center: position,
          radius: _getHeatmapRadius(complaint.severity),
          fillColor: color.withOpacity(0.25),
          strokeColor: color.withOpacity(0.5),
          strokeWidth: 2,
        ),
      );

      // Add inner intense circle
      circles.add(
        Circle(
          circleId: CircleId('inner_${complaint.id}'),
          center: position,
          radius: _getHeatmapRadius(complaint.severity) * 0.4,
          fillColor: color.withOpacity(0.45),
          strokeWidth: 0,
        ),
      );

      // Add marker
      markers.add(
        Marker(
          markerId: MarkerId(complaint.id),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(complaint.severity)),
          infoWindow: InfoWindow(
            title: complaint.title,
            snippet: '${complaint.severity.displayName} - ${complaint.issueType}',
          ),
          onTap: () {
            widget.onMarkerTapped?.call(complaint);
          },
        ),
      );
    }

    setState(() {
      _heatmapCircles = circles;
      _markers = markers;
    });
  }

  Color _getSeverityColor(SeverityLevel severity) {
    switch (severity) {
      case SeverityLevel.low:
        return AppColors.severityLow;
      case SeverityLevel.medium:
        return AppColors.severityMedium;
      case SeverityLevel.high:
        return AppColors.severityHigh;
      case SeverityLevel.critical:
        return AppColors.severityCritical;
    }
  }

  double _getHeatmapRadius(SeverityLevel severity) {
    switch (severity) {
      case SeverityLevel.low:
        return 150;
      case SeverityLevel.medium:
        return 200;
      case SeverityLevel.high:
        return 250;
      case SeverityLevel.critical:
        return 300;
    }
  }

  double _getMarkerHue(SeverityLevel severity) {
    switch (severity) {
      case SeverityLevel.low:
        return BitmapDescriptor.hueGreen;
      case SeverityLevel.medium:
        return BitmapDescriptor.hueYellow;
      case SeverityLevel.high:
        return BitmapDescriptor.hueOrange;
      case SeverityLevel.critical:
        return BitmapDescriptor.hueRed;
    }
  }

  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition,
            circles: _heatmapCircles,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        // Zoom controls
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            children: [
              _MapButton(
                icon: Icons.my_location,
                onTap: _goToCurrentLocation,
              ),
              const SizedBox(height: 8),
              _MapButton(
                icon: Icons.add,
                onTap: () async {
                  final controller = await _controller.future;
                  controller.animateCamera(CameraUpdate.zoomIn());
                },
              ),
              const SizedBox(height: 8),
              _MapButton(
                icon: Icons.remove,
                onTap: () async {
                  final controller = await _controller.future;
                  controller.animateCamera(CameraUpdate.zoomOut());
                },
              ),
            ],
          ),
        ),
        // Heatmap legend
        Positioned(
          left: 12,
          top: 12,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Issue Density',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LegendDot(color: AppColors.severityLow),
                    _LegendDot(color: AppColors.severityMedium),
                    _LegendDot(color: AppColors.severityHigh),
                    _LegendDot(color: AppColors.severityCritical),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;

  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0.3)],
        ),
      ),
    );
  }
}
