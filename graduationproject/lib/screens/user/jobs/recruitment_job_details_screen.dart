import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_button.dart';

class RecruitmentJobDetailsScreen extends StatelessWidget {
  const RecruitmentJobDetailsScreen({super.key, required this.job});

  final RecruitmentJob job;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            job.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text('${job.companyName} • ${job.location}'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: job.tags.map((e) => Chip(label: Text(e))).toList(),
          ),
          const SizedBox(height: 12),
          Text('Type: ${job.type}'),
          Text('Salary: ${job.salaryRange}'),
          const SizedBox(height: 16),
          Text(
            'Role Overview',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'You will build scalable features, collaborate with product teams, and ship high quality experiences for job seekers and companies.',
          ),
          const SizedBox(height: 18),
          AppButton(
            label: 'Apply',
            onPressed: () => Navigator.of(context).pushNamed(
              AppRoutes.userJobApplication,
              arguments: job,
            ),
          ),
        ],
      ),
    );
  }
}
