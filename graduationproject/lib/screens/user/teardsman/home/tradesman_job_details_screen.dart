import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import '../../../../../shared/state/recruitment_sync_store.dart';
import '../../../../../shared/widgets/app_button.dart';
import 'tradesman_apply_job_screen.dart';

class TradesmanJobDetailsScreen extends StatelessWidget {
  const TradesmanJobDetailsScreen({super.key, required this.job});

  final RecruitmentJob job;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5F1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(t.tr(en: 'Job Details', ar: 'تفاصيل الوظيفة')),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final isSaved = store.savedJobIds.contains(job.id);
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(job.logoIcon ?? Icons.work_outline, 
                          color: const Color(0xFF49769F), size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      job.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job.companyName,
                      style: const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                    children: [
                      _buildBadge(job.salaryRange, Colors.grey),
                      const SizedBox(width: 10),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: job.type.split(RegExp(r'[•,;]')).map((t) {
                          final type = t.trim();
                          if (type.isEmpty) return const SizedBox.shrink();
                          return _buildBadge(type, _getJobTypeColor(type));
                        }).toList(),
                      ),
                    ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Description Section
              if (job.description.trim().isNotEmpty) ...[
                Text(
                  t.tr(en: 'Description', ar: 'الوصف الوظيفي'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  job.description,
                  style: const TextStyle(color: Colors.black54, fontSize: 15, height: 1.6),
                ),
                const SizedBox(height: 24),
              ],

              // Responsibilities Section
              if (job.responsibilities.isNotEmpty) ...[
                Text(
                  t.tr(en: 'Responsibilities', ar: 'المسؤوليات'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ...job.responsibilities.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Color(0xFF49769F), fontWeight: FontWeight.bold)),
                      Expanded(child: Text(item, style: const TextStyle(color: Colors.black54, fontSize: 14))),
                    ],
                  ),
                )),
                const SizedBox(height: 24),
              ],

              // Qualifications Section
              if (job.qualifications.isNotEmpty) ...[
                Text(
                  t.tr(en: 'Qualifications', ar: 'المؤهلات'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ...job.qualifications.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Color(0xFF49769F), fontWeight: FontWeight.bold)),
                      Expanded(child: Text(item, style: const TextStyle(color: Colors.black54, fontSize: 14))),
                    ],
                  ),
                )),
                const SizedBox(height: 24),
              ],

              // Benefits Section
              if (job.benefits.isNotEmpty) ...[
                Text(
                  t.tr(en: 'Benefits', ar: 'المميزات والفوائد'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: job.benefits.map((item) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.withOpacity(0.1)),
                    ),
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 24),
              ],

              // Tags Section
              if (job.tags.isNotEmpty) ...[
                Text(
                  t.tr(en: 'Skills', ar: 'المهارات'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: job.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF49769F).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF49769F).withOpacity(0.1)),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(color: Color(0xFF49769F), fontWeight: FontWeight.w600),
                    ),
                  )).toList(),
                ),
              ],
              const SizedBox(height: 40),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: t.tr(en: 'Apply Now', ar: 'قدّم الآن'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TradesmanApplyJobScreen(job: job),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: IconButton(
                      onPressed: () => store.toggleSaveJob(job.id),
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: const Color(0xFF49769F),
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

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

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
