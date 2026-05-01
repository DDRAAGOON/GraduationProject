import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/utils/image_helper.dart';
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
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundImage: getAppImageProvider(job.companyLogoUrl),
                child: getAppImageProvider(job.companyLogoUrl) == null
                    ? const Icon(Icons.business, size: 14)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(job.companyName)),
            ],
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hiring ${job.capacity} people',
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
              Text(
                '${job.acceptedCount} / ${job.capacity} Accepted',
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: job.capacity > 0 ? (job.acceptedCount / job.capacity).clamp(0.0, 1.0) : 0,
              backgroundColor: Theme.of(context).dividerColor.withOpacity(0.1),
              color: job.acceptedCount >= job.capacity ? Colors.green : Theme.of(context).colorScheme.primary,
              minHeight: 8,
            ),
          ),
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
              children: job.tags.where((tag) => tag.trim().toLowerCase() != 'technical').map((e) => Chip(label: Text(e))).toList(),
            ),
            const SizedBox(height: 12),
          ],
          if (job.category.toLowerCase() != 'services') ...[
            Text('Salary: ${job.salaryRange}'),
          ],
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
