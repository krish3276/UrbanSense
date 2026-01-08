import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../models/complaint_model.dart';
import '../../../providers/complaint_provider.dart';
import '../../../utils/department_utils.dart';

/// AI Analysis Preview Screen
class AiAnalysisScreen extends StatefulWidget {
  final String title;
  final String description;
  final String issueType;
  final String location;
  final String? imagePath;

  const AiAnalysisScreen({
    super.key,
    required this.title,
    required this.description,
    required this.issueType,
    required this.location,
    this.imagePath,
  });

  @override
  State<AiAnalysisScreen> createState() => _AiAnalysisScreenState();
}

class _AiAnalysisScreenState extends State<AiAnalysisScreen>
    with SingleTickerProviderStateMixin {
  bool _isAnalyzing = true;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  // Mock AI analysis results
  late SeverityLevel _detectedSeverity;
  late String _estimatedTime;
  late String _suggestedDepartment;
  late List<String> _aiInsights;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Simulate AI analysis
    _runAnalysis();
  }

  Future<void> _runAnalysis() async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Use DepartmentUtils to get the appropriate department
    _suggestedDepartment = DepartmentUtils.getDepartmentForIssueType(widget.issueType);
    
    // Mock AI results based on issue type
    switch (widget.issueType) {
      case 'Road Damage':
        _detectedSeverity = SeverityLevel.high;
        _estimatedTime = '2-3 days';
        _aiInsights = [
          'Pothole detected with depth estimation: Medium',
          'Road surface damage level: Moderate to Severe',
          'Traffic impact: High (main road)',
          'Similar issues resolved in area: 15',
        ];
        break;
      case 'Water Leakage':
        _detectedSeverity = SeverityLevel.critical;
        _estimatedTime = '4-6 hours';
        _aiInsights = [
          'Water loss rate: Significant',
          'Potential pipe damage: Main line',
          'Flooding risk: High',
          'Priority escalation: Recommended',
        ];
        break;
      case 'Street Light':
        _detectedSeverity = SeverityLevel.medium;
        _estimatedTime = '1-2 days';
        _aiInsights = [
          'Light status: Non-functional',
          'Area lighting coverage: Reduced by 40%',
          'Safety concern: Moderate',
          'Nearby lights checked: 3 functional',
        ];
        break;
      case 'Garbage':
        _detectedSeverity = SeverityLevel.high;
        _estimatedTime = '1 day';
        _aiInsights = [
          'Waste accumulation detected',
          'Health hazard risk: Moderate',
          'Requires immediate attention',
        ];
        break;
      default:
        _detectedSeverity = SeverityLevel.medium;
        _estimatedTime = '3-5 days';
        _aiInsights = [
          'Issue categorized successfully',
          'Standard processing timeline applies',
          'No escalation required',
        ];
    }

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
      });
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getSeverityColor() {
    switch (_detectedSeverity) {
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

  Future<void> _submitComplaint() async {
    final provider = context.read<ComplaintProvider>();
    final complaint = await provider.addComplaint(
      title: widget.title,
      description: widget.description,
      issueType: widget.issueType,
      location: widget.location,
      department: _suggestedDepartment,
      severity: _detectedSeverity,
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complaint submitted successfully!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.severityLow,
        ),
      );
      context.go('/citizen/tracking/${complaint.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Analysis'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _isAnalyzing ? _buildAnalyzingView() : _buildResultsView(),
    );
  }

  Widget _buildAnalyzingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                size: 64,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'AI Analyzing Your Report',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Our AI is analyzing your issue to determine severity, priority, and the best department to handle it.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          Row(
            children: [
              _ProgressDot(isActive: true, isCompleted: true, label: '1'),
              Expanded(child: _ProgressLine(isActive: true)),
              _ProgressDot(isActive: true, isCompleted: false, label: '2'),
              Expanded(child: _ProgressLine(isActive: false)),
              _ProgressDot(isActive: false, isCompleted: false, label: '3'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Details', style: TextStyle(fontSize: 12, color: AppColors.severityLow, fontWeight: FontWeight.w600)),
              Text('AI Review', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
              Text('Submit', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
            ],
          ),
          const SizedBox(height: 24),

          // AI Analysis header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Analysis Complete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Review the findings below',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 32,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Issue summary
          Text(
            'Issue Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getSeverityColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.report_problem,
                          color: _getSeverityColor(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              widget.issueType,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    widget.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // AI Detected metrics
          Text(
            'AI Detection Results',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: Icons.warning,
                  label: 'Severity',
                  value: _detectedSeverity.displayName,
                  color: _getSeverityColor(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  icon: Icons.schedule,
                  label: 'ETA',
                  value: _estimatedTime,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _MetricCard(
            icon: Icons.business,
            label: 'Suggested Department',
            value: _suggestedDepartment,
            color: AppColors.secondary,
            isFullWidth: true,
          ),
          const SizedBox(height: 24),

          // AI Insights
          Text(
            'AI Insights',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _aiInsights.map((insight) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.insights,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            insight,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Edit Report'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _submitComplaint,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Confirm & Submit'),
                      SizedBox(width: 8),
                      Icon(Icons.send, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressDot extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;
  final String label;

  const _ProgressDot({
    required this.isActive,
    required this.isCompleted,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.severityLow
            : isActive
                ? AppColors.primary
                : AppColors.surfaceVariant,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.black, size: 18)
            : Text(
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
        color: isActive ? AppColors.severityLow : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isFullWidth;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
