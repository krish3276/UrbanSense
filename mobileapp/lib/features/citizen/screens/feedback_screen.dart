import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../providers/complaint_provider.dart';

/// Feedback and rating screen
class FeedbackScreen extends StatefulWidget {
  final String complaintId;

  const FeedbackScreen({super.key, required this.complaintId});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double _rating = 0;
  final _feedbackController = TextEditingController();
  bool _hasImage = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _uploadImage() {
    setState(() {
      _hasImage = !_hasImage;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_hasImage ? 'Image uploaded (mock)' : 'Image removed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submitFeedback() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a rating'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final provider = context.read<ComplaintProvider>();
    await provider.submitFeedback(
      widget.complaintId,
      _rating,
      _feedbackController.text,
    );

    setState(() {
      _isSubmitting = false;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.severityLow.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.severityLow,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Thank You!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your feedback has been submitted successfully.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/citizen');
                  },
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.severityMedium.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.rate_review_outlined,
                      size: 48,
                      color: AppColors.severityMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rate Your Experience',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your feedback helps us improve our services',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Star rating
            Text(
              'Overall Rating',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;
                        return GestureDetector(
                          onTap: () => setState(() => _rating = starValue.toDouble()),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              _rating >= starValue
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 48,
                              color: _rating >= starValue
                                  ? AppColors.severityMedium
                                  : AppColors.textHint,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _rating == 0
                          ? 'Tap to rate'
                          : _rating <= 2
                              ? 'Poor'
                              : _rating <= 3
                                  ? 'Average'
                                  : _rating <= 4
                                      ? 'Good'
                                      : 'Excellent',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _rating == 0
                                ? AppColors.textHint
                                : AppColors.severityMedium,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Comment
            Text(
              'Your Comments (Optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Tell us about your experience...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            // Upload after-fix image
            Text(
              'After-Fix Photo (Optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload a photo showing the resolved issue',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _uploadImage,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _hasImage
                      ? AppColors.severityLow.withOpacity(0.1)
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _hasImage ? AppColors.severityLow : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _hasImage ? Icons.check_circle : Icons.add_a_photo_outlined,
                      size: 48,
                      color: _hasImage ? AppColors.severityLow : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _hasImage ? 'Photo Uploaded' : 'Tap to Upload Photo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _hasImage ? AppColors.severityLow : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.severityMedium,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'Submit Feedback',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => context.go('/citizen'),
                child: const Text('Skip for now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
