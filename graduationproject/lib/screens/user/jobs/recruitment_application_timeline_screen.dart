import 'package:flutter/material.dart';

import '../../../shared/state/recruitment_sync_store.dart';

class RecruitmentApplicationTimelineScreen extends StatelessWidget {
  const RecruitmentApplicationTimelineScreen({super.key, required this.application});

  final RecruitmentApplication application;

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Applied',
      'In Review',
      'Shortlisted',
      'Final Review',
      'Hired',
    ];
    final normalizedStatus =
        application.status == 'Interview' ? 'Final Review' : application.status;
    final currentIndex = steps.indexOf(normalizedStatus);
    return Scaffold(
      appBar: AppBar(title: const Text('Application Timeline')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final active = index <= (currentIndex < 0 ? 0 : currentIndex);
          return ListTile(
            leading: Icon(
              active ? Icons.check_circle : Icons.radio_button_unchecked,
              color: active ? Theme.of(context).colorScheme.primary : null,
            ),
            title: Text(steps[index]),
            subtitle: index == currentIndex
                ? Text('Current status for ${application.jobTitle}')
                : null,
          );
        },
      ),
    );
  }
}
