import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../models/complaint_model.dart';
import '../../../providers/complaint_provider.dart';
import '../widgets/priority_chip.dart';

/// Issue details screen for officers
class IssueDetailsScreen extends StatefulWidget {
  final String complaintId;

  const IssueDetailsScreen({super.key, required this.complaintId});

  @override
  State<IssueDetailsScreen> createState() => _IssueDetailsScreenState();
}

class _IssueDetailsScreenState extends State<IssueDetailsScreen> {
  ComplaintStatus? _selectedStatus;
  bool _hasResolutionProof = false;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.submitted:
        return AppColors.statusSubmitted;
      case ComplaintStatus.inProgress:
        return AppColors.statusInProgress;
      case ComplaintStatus.resolved:
        return AppColors.statusResolved;
      case ComplaintStatus.closed:
        return AppColors.statusClosed;
    }
  }

  void _uploadProof() {
    setState(() {
      _hasResolutionProof = !_hasResolutionProof;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_hasResolutionProof ? 'Proof uploaded (mock)' : 'Proof removed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _updateStatus(ComplaintModel complaint) async {
    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a status'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final provider = context.read<ComplaintProvider>();
    await provider.updateComplaintStatus(
      complaint.id,
      _selectedStatus!,
      _noteController.text.isEmpty
          ? 'Status updated to ${_selectedStatus!.displayName}'
          : _noteController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated to ${_selectedStatus!.displayName}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.severityLow,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue Details'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.phone, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('Call Citizen'),
                    ],
                  ),
                  content: const Text('Would you like to call the citizen who reported this issue?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.phone, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Calling citizen... (Mock)'),
                              ],
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Call Now'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.phone_outlined),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('More Options'),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.message),
                        title: const Text('Send Message'),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Message feature coming soon'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.share),
                        title: const Text('Share Issue'),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sharing... (Mock)'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.flag),
                        title: const Text('Flag Issue'),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Issue flagged'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Consumer<ComplaintProvider>(
        builder: (context, provider, child) {
          final complaint = provider.getComplaintById(widget.complaintId);

          if (complaint == null) {
            return const Center(
              child: Text('Complaint not found'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with severity and status
                Row(
                  children: [
                    PriorityChip(severity: complaint.severity),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(complaint.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        complaint.status.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(complaint.status),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '#${complaint.id}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  complaint.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),

                // Issue type and time
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        complaint.issueType,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(complaint.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      complaint.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Location
                Text(
                  'Location',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.location_on, color: AppColors.primary),
                        ),
                        title: Text(complaint.location),
                        subtitle: Text(
                          'Lat: ${complaint.latitude.toStringAsFixed(4)}, Lng: ${complaint.longitude.toStringAsFixed(4)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.navigation, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text('Opening navigation to issue location...'),
                                    ],
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                            icon: const Icon(Icons.directions),
                            label: const Text('Start Navigation'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Citizen info
                Text(
                  'Reported By',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(
                        complaint.citizenName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(complaint.citizenName),
                    subtitle: const Text('Citizen'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.phone, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text('Calling ${complaint.citizenName}... (Mock)'),
                                  ],
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppColors.info,
                              ),
                            );
                          },
                          icon: const Icon(Icons.phone_outlined),
                          color: AppColors.info,
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Message ${complaint.citizenName}'),
                                content: TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Type your message...',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Message sent (Mock)'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    child: const Text('Send'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.message_outlined),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Timeline
                Text(
                  'Timeline',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: List.generate(
                        complaint.timeline.length,
                        (index) {
                          final update = complaint.timeline[complaint.timeline.length - 1 - index];
                          final isFirst = index == 0;
                          final isLast = index == complaint.timeline.length - 1;

                          return _TimelineItem(
                            status: update.status,
                            message: update.message,
                            timestamp: update.timestamp,
                            isFirst: isFirst,
                            isLast: isLast,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Status update section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.edit_note, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Update Status',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Status dropdown
                      DropdownButtonFormField<ComplaintStatus>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'New Status',
                          prefixIcon: Icon(Icons.sync),
                        ),
                        items: ComplaintStatus.values
                            .where((s) => s != ComplaintStatus.submitted)
                            .map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(status),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(status.displayName),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedStatus = value),
                      ),
                      const SizedBox(height: 16),

                      // Note field
                      TextFormField(
                        controller: _noteController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Add Note (Optional)',
                          hintText: 'Describe the action taken...',
                          prefixIcon: Icon(Icons.note_add),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Upload resolution proof
                      if (_selectedStatus == ComplaintStatus.resolved)
                        Column(
                          children: [
                            InkWell(
                              onTap: _uploadProof,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _hasResolutionProof
                                      ? AppColors.severityLow.withOpacity(0.1)
                                      : AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _hasResolutionProof
                                        ? AppColors.severityLow
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _hasResolutionProof
                                          ? Icons.check_circle
                                          : Icons.add_a_photo_outlined,
                                      color: _hasResolutionProof
                                          ? AppColors.severityLow
                                          : AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _hasResolutionProof
                                          ? 'Resolution Proof Uploaded'
                                          : 'Upload Resolution Proof',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: _hasResolutionProof
                                            ? AppColors.severityLow
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),

                      // Update button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _updateStatus(complaint),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Update Status'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _TimelineItem extends StatelessWidget {
  final ComplaintStatus status;
  final String message;
  final DateTime timestamp;
  final bool isFirst;
  final bool isLast;

  const _TimelineItem({
    required this.status,
    required this.message,
    required this.timestamp,
    required this.isFirst,
    required this.isLast,
  });

  Color _getStatusColor() {
    switch (status) {
      case ComplaintStatus.submitted:
        return AppColors.statusSubmitted;
      case ComplaintStatus.inProgress:
        return AppColors.statusInProgress;
      case ComplaintStatus.resolved:
        return AppColors.statusResolved;
      case ComplaintStatus.closed:
        return AppColors.statusClosed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isFirst ? _getStatusColor() : _getStatusColor().withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: isFirst
                    ? const Icon(Icons.check, color: Colors.white, size: 12)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.surfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: isFirst ? FontWeight.w600 : FontWeight.normal,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textHint,
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

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}
