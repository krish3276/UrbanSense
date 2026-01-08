import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';

/// Location input mode
enum LocationMode {
  gps,
  manual,
}

/// Report issue screen
class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _manualLocationController = TextEditingController();
  String? _selectedIssueType;
  String? _imagePath;
  bool _hasVoiceNote = false;
  LocationMode _locationMode = LocationMode.gps;
  final String _mockGPSLocation = 'MG Road, Near City Mall, Ahmedabad';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _manualLocationController.dispose();
    super.dispose();
  }

  void _pickImage() {
    // Mock image picker
    setState(() {
      _imagePath = 'mock_image.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image selected (mock)'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _recordVoice() {
    // Mock voice recorder
    setState(() {
      _hasVoiceNote = !_hasVoiceNote;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_hasVoiceNote ? 'Voice note recorded (mock)' : 'Voice note removed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submitReport() {
    if (_formKey.currentState!.validate() && _selectedIssueType != null) {
      // Get the location based on selected mode
      final location = _locationMode == LocationMode.gps
          ? _mockGPSLocation
          : _manualLocationController.text;
      
      // Navigate to AI analysis screen
      context.push(
        '/citizen/ai-analysis',
        extra: {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'issueType': _selectedIssueType,
          'location': location,
          'imagePath': _imagePath,
        },
      );
    } else if (_selectedIssueType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an issue type'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Issue'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              Row(
                children: [
                  _ProgressDot(isActive: true, label: '1'),
                  Expanded(child: _ProgressLine(isActive: false)),
                  _ProgressDot(isActive: false, label: '2'),
                  Expanded(child: _ProgressLine(isActive: false)),
                  _ProgressDot(isActive: false, label: '3'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Details', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  Text('AI Review', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                  Text('Submit', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                ],
              ),
              const SizedBox(height: 32),

              // Issue type dropdown
              Text(
                'Issue Type',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedIssueType,
                decoration: const InputDecoration(
                  hintText: 'Select issue type',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: IssueTypes.all.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedIssueType = value),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Issue Title',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Brief title of the issue',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Description
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe the issue in detail...',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Location (GPS or Manual)
              Text(
                'Location',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              
              // Location mode selector
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _locationMode = LocationMode.gps),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _locationMode == LocationMode.gps
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.gps_fixed,
                                size: 18,
                                color: _locationMode == LocationMode.gps
                                    ? Colors.black
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Auto GPS',
                                style: TextStyle(
                                  color: _locationMode == LocationMode.gps
                                      ? Colors.black
                                      : AppColors.textSecondary,
                                  fontWeight: _locationMode == LocationMode.gps
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _locationMode = LocationMode.manual),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _locationMode == LocationMode.manual
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit_location_alt,
                                size: 18,
                                color: _locationMode == LocationMode.manual
                                    ? Colors.black
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Manual Entry',
                                style: TextStyle(
                                  color: _locationMode == LocationMode.manual
                                      ? Colors.black
                                      : AppColors.textSecondary,
                                  fontWeight: _locationMode == LocationMode.manual
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Location display/input based on mode
              if (_locationMode == LocationMode.gps)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.gps_fixed, size: 14, color: AppColors.severityLow),
                                const SizedBox(width: 4),
                                Text(
                                  'Auto-detected',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.severityLow,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _mockGPSLocation,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                TextFormField(
                  controller: _manualLocationController,
                  decoration: const InputDecoration(
                    hintText: 'Enter location (e.g., Street, Area, City)',
                    prefixIcon: Icon(Icons.edit_location_alt),
                  ),
                  validator: (value) {
                    if (_locationMode == LocationMode.manual &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                  maxLines: 2,
                ),
              const SizedBox(height: 20),

              // Media attachments
              Text(
                'Attachments',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Image upload
                  Expanded(
                    child: InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _imagePath != null
                              ? AppColors.severityLow.withOpacity(0.1)
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _imagePath != null
                                ? AppColors.severityLow
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _imagePath != null
                                  ? Icons.check_circle
                                  : Icons.camera_alt_outlined,
                              size: 32,
                              color: _imagePath != null
                                  ? AppColors.severityLow
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _imagePath != null ? 'Image Added' : 'Add Photo',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _imagePath != null
                                    ? AppColors.severityLow
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Voice record
                  Expanded(
                    child: InkWell(
                      onTap: _recordVoice,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _hasVoiceNote
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _hasVoiceNote
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _hasVoiceNote ? Icons.check_circle : Icons.mic_outlined,
                              size: 32,
                              color: _hasVoiceNote
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _hasVoiceNote ? 'Voice Added' : 'Record Voice',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _hasVoiceNote
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue to AI Analysis'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressDot extends StatelessWidget {
  final bool isActive;
  final String label;

  const _ProgressDot({required this.isActive, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surfaceVariant,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final bool isActive;

  const _ProgressLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
