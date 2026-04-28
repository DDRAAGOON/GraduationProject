import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_button.dart';

class RecruitmentJobDetailsScreen extends StatelessWidget {
  const RecruitmentJobDetailsScreen({super.key, required this.job});

  final RecruitmentJob job;

  Color _getJobTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'full-time':
        return Colors.green;
      case 'part-time':
        return Colors.blue;
      case 'remote':
        return Colors.purple;
      case 'freelance':
        return Colors.teal;
      case 'one-time':
        return Colors.amber;
      case 'internship':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getJobTypeColor(job.type);
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
          Text(job.companyName),
          const SizedBox(height: 12),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Type Badges
              ...job.type.split(RegExp(r'[•,;]')).map((t) {
                final type = t.trim();
                if (type.isEmpty) return const SizedBox.shrink();
                final color = _getJobTypeColor(type);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
          const SizedBox(height: 12),
          if (job.tags.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              children: job.tags.map((e) => Chip(label: Text(e))).toList(),
            ),
            const SizedBox(height: 12),
          ],
          Text('Salary: ${job.salaryRange}'),
          const SizedBox(height: 24),

          if (job.description.trim().isNotEmpty) ...[
            Text(
              'Role Overview',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(job.description),
            const SizedBox(height: 24),
          ],

          if (job.responsibilities.isNotEmpty) ...[
            Text(
              'Responsibilities',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...job.responsibilities.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
            const SizedBox(height: 24),
          ],

          if (job.qualifications.isNotEmpty) ...[
            Text(
              'Qualifications',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...job.qualifications.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
            const SizedBox(height: 24),
          ],

          if (job.benefits.isNotEmpty) ...[
            Text(
              'Benefits',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: job.benefits.map((item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(item, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
              )).toList(),
            ),
            const SizedBox(height: 24),
          ],
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
