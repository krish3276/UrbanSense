import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../models/complaint_model.dart';
import '../../../providers/complaint_provider.dart';
import '../widgets/priority_chip.dart';

/// Officer map screen with full-featured Google Maps
class OfficerMapScreen extends StatefulWidget {
  const OfficerMapScreen({super.key});

  @override
  State<OfficerMapScreen> createState() => _OfficerMapScreenState();
}

class _OfficerMapScreenState extends State<OfficerMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Circle> _heatmapCircles = {};
  Set<Marker> _markers = {};
  ComplaintModel? _selectedComplaint;
  String _selectedFilter = 'All';
  bool _showHeatmap = true;
  MapType _mapType = MapType.normal;

  // Center on Ahmedabad, India
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.0225, 72.5714),
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buildMapElements();
    });
  }

  void _buildMapElements() {
    final provider = context.read<ComplaintProvider>();
    var complaints = provider.getOfficerComplaints();

    // Apply filter
    if (_selectedFilter != 'All') {
      complaints = complaints.where((c) {
        return c.severity.displayName == _selectedFilter;
      }).toList();
    }

    final circles = <Circle>{};
    final markers = <Marker>{};

    for (final complaint in complaints) {
      final position = LatLng(complaint.latitude, complaint.longitude);
      final color = _getSeverityColor(complaint.severity);

      if (_showHeatmap) {
        // Heatmap circle
        circles.add(
          Circle(
            circleId: CircleId('heatmap_${complaint.id}'),
            center: position,
            radius: _getHeatmapRadius(complaint.severity),
            fillColor: color.withOpacity(0.3),
            strokeColor: color.withOpacity(0.6),
            strokeWidth: 2,
          ),
        );
      }

      // Marker
      markers.add(
        Marker(
          markerId: MarkerId(complaint.id),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(complaint.severity)),
          onTap: () {
            setState(() => _selectedComplaint = complaint);
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
        return 100;
      case SeverityLevel.medium:
        return 150;
      case SeverityLevel.high:
        return 200;
      case SeverityLevel.critical:
        return 250;
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

  Future<void> _goToLocation(LatLng position) async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            mapType: _mapType,
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
            onTap: (_) {
              setState(() => _selectedComplaint = null);
            },
          ),

          // Top controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Title bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.map, color: AppColors.secondary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Issue Map',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Consumer<ComplaintProvider>(
                              builder: (context, provider, child) {
                                final count = provider.getOfficerComplaints().length;
                                return Text(
                                  '$count assigned issues',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      // Map type toggle
                      _MapControlButton(
                        icon: Icons.layers,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => _MapTypeSelector(
                              currentType: _mapType,
                              onSelected: (type) {
                                setState(() => _mapType = type);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      // Heatmap toggle
                      _MapControlButton(
                        icon: _showHeatmap ? Icons.blur_on : Icons.blur_off,
                        isActive: _showHeatmap,
                        onTap: () {
                          setState(() => _showHeatmap = !_showHeatmap);
                          _buildMapElements();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Critical', 'High', 'Medium', 'Low'].map((filter) {
                      final isSelected = _selectedFilter == filter;
                      final color = filter == 'All'
                          ? AppColors.secondary
                          : filter == 'Critical'
                              ? AppColors.severityCritical
                              : filter == 'High'
                                  ? AppColors.severityHigh
                                  : filter == 'Medium'
                                      ? AppColors.severityMedium
                                      : AppColors.severityLow;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedFilter = filter);
                            _buildMapElements();
                          },
                          backgroundColor: Colors.white,
                          selectedColor: color.withOpacity(0.2),
                          checkmarkColor: color,
                          labelStyle: TextStyle(
                            color: isSelected ? color : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 13,
                          ),
                          elevation: 2,
                          shadowColor: Colors.black.withOpacity(0.1),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Right side controls
          Positioned(
            right: 16,
            bottom: _selectedComplaint != null ? 200 : 100,
            child: Column(
              children: [
                _MapControlButton(
                  icon: Icons.my_location,
                  onTap: () async {
                    final controller = await _controller.future;
                    controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
                  },
                ),
                const SizedBox(height: 8),
                _MapControlButton(
                  icon: Icons.add,
                  onTap: () async {
                    final controller = await _controller.future;
                    controller.animateCamera(CameraUpdate.zoomIn());
                  },
                ),
                const SizedBox(height: 8),
                _MapControlButton(
                  icon: Icons.remove,
                  onTap: () async {
                    final controller = await _controller.future;
                    controller.animateCamera(CameraUpdate.zoomOut());
                  },
                ),
              ],
            ),
          ),

          // Legend
          Positioned(
            left: 16,
            bottom: _selectedComplaint != null ? 200 : 100,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Priority',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _LegendRow(color: AppColors.severityCritical, label: 'Critical'),
                  _LegendRow(color: AppColors.severityHigh, label: 'High'),
                  _LegendRow(color: AppColors.severityMedium, label: 'Medium'),
                  _LegendRow(color: AppColors.severityLow, label: 'Low'),
                ],
              ),
            ),
          ),

          // Selected complaint card
          if (_selectedComplaint != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _IssueCard(
                complaint: _selectedComplaint!,
                onTap: () => context.push('/officer/issue/${_selectedComplaint!.id}'),
                onClose: () => setState(() => _selectedComplaint = null),
              ),
            ),
        ],
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _MapControlButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? AppColors.secondary.withOpacity(0.1) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 22,
            color: isActive ? AppColors.secondary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendRow({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _MapTypeSelector extends StatelessWidget {
  final MapType currentType;
  final Function(MapType) onSelected;

  const _MapTypeSelector({required this.currentType, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Map Type',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MapTypeOption(
                icon: Icons.map,
                label: 'Standard',
                isSelected: currentType == MapType.normal,
                onTap: () => onSelected(MapType.normal),
              ),
              _MapTypeOption(
                icon: Icons.satellite,
                label: 'Satellite',
                isSelected: currentType == MapType.satellite,
                onTap: () => onSelected(MapType.satellite),
              ),
              _MapTypeOption(
                icon: Icons.terrain,
                label: 'Terrain',
                isSelected: currentType == MapType.terrain,
                onTap: () => onSelected(MapType.terrain),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _MapTypeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MapTypeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondary.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.secondary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.secondary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.secondary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _IssueCard extends StatelessWidget {
  final ComplaintModel complaint;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const _IssueCard({
    required this.complaint,
    required this.onTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  PriorityChip(severity: complaint.severity),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.statusInProgress.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      complaint.status.displayName,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.statusInProgress,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                complaint.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      complaint.location,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.directions, size: 18),
                      label: const Text('Directions'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                        side: const BorderSide(color: AppColors.secondary),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
