import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import '../../../../../shared/state/recruitment_sync_store.dart';
import '../../../../../shared/widgets/app_button.dart';
import 'tradesman_apply_job_screen.dart';

class TradesmanJobDetailsScreen extends StatelessWidget {
  const TradesmanJobDetailsScreen({super.key, required this.job});

  final RecruitmentJob job;

  Color _getJobTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'full-time':
        return Colors.green;
      case 'part-time':
        return Colors.blue;
      case 'contract':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;
    final typeColor = _getJobTypeColor(job.type);

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
                      "${job.companyName} • ${job.location}",
                      style: const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildBadge(job.type, typeColor),
                        const SizedBox(width: 10),
                        _buildBadge(job.salaryRange, Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Description Section
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
                t.tr(
                  en: "We are looking for a skilled ${job.title} to join our team in ${job.location}. The ideal candidate should have experience in ${job.tags.join(', ')} and be able to deliver high-quality results.",
                  ar: "نحن نبحث عن ${job.title} محترف للانضمام إلى فريقنا في ${job.location}. يجب أن يمتلك المرشح المثالي خبرة في ${job.tags.join(', ')} والقدرة على تقديم نتائج عالية الجودة."
                ),
                style: const TextStyle(color: Colors.black54, fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 24),

              // Requirements / Tags
              Text(
                t.tr(en: 'Requirements', ar: 'المتطلبات والمهارات'),
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

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
