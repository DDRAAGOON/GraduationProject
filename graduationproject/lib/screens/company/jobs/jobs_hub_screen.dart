// List and search all jobs for the signed-in company.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/models/job.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../widgets/company_app_bar_actions.dart';
import '../widgets/company_bottom_nav.dart';
import '../widgets/glowing_chatbot_fab.dart';
import '../../user/messages/chat_thread_screen.dart';
import '../../../constants/app_images.dart';

class CompanyJobsHubScreen extends StatefulWidget {
  const CompanyJobsHubScreen({super.key});

  @override
  State<CompanyJobsHubScreen> createState() => _CompanyJobsHubScreenState();
}

class _CompanyJobsHubScreenState extends State<CompanyJobsHubScreen> {
  final Set<String> _selectedStatuses = {};
  final Set<String> _selectedTypes = {};

  @override
  void initState() {
    super.initState();
    RecruitmentSyncService.instance.startPolling();
  }

  @override
  Widget build(BuildContext context) {
    final companyStore = CompanyStore.instance;
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return AppScaffold(
      title: t.job,
      showBack: false,
      leading: const CompanyProfileLeading(),
      actions: const [CompanyAppBarActions()],
      showAppBarDivider: true,
      bottomNavigationBar: const CompanyBottomNav(
        current: CompanyTab.applicants,
      ),
      floatingActionButton: GlowingChatbotFAB(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatThreadScreen(
              name: t.isAr ? 'مساعد جوبيتو الذكي' : 'Jobito AI Assistant',
              image: AppImages.jobito,
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          companyStore,
          RecruitmentSyncStore.instance,
        ]),
        builder: (context, _) {
          final allJobs = RecruitmentSyncStore.instance.jobs;

          // ✅ Logging للتشخيص
          if (kDebugMode) {
            debugPrint('📊 Total jobs in store: ${allJobs.length}');
            debugPrint('🏢 Company ID: ${companyStore.companyId}');
            debugPrint('🏢 Company Name: ${companyStore.companyName}');

            if (allJobs.isNotEmpty) {
              final firstJob = allJobs.first;
              debugPrint('📋 First job:');
              debugPrint('   - ID: ${firstJob.id}');
              debugPrint('   - Title: ${firstJob.title}');
              debugPrint('   - Company ID: ${firstJob.companyId}');
              debugPrint('   - Company Name: ${firstJob.companyName}');
            }
          }

          // ✅ فلترة صحيحة باستخدام companyId
          final companyJobs = allJobs.where((j) {
            // ✅ الأولوية لـ companyName
            if (companyStore.companyName.isNotEmpty &&
                j.companyName.isNotEmpty) {
              return j.companyName.trim().toLowerCase() ==
                  companyStore.companyName.trim().toLowerCase();
            }

            // ✅ fallback لـ companyId لو موجود
            if (companyStore.companyId.isNotEmpty && j.companyId.isNotEmpty) {
              return j.companyId == companyStore.companyId;
            }

            return false;
          }).toList();

          if (kDebugMode) {
            debugPrint(
              '✅ Filtered jobs: ${companyJobs.length} (from ${allJobs.length})',
            );
            debugPrint('🏢 Filtering by: ${companyStore.companyName}');
          }
          // ✅ عرض وظائف الشركة فقط (بدون mock)
          final displayJobs = companyJobs;

          final filteredJobs = displayJobs.where((j) {
            final jobStatus = j.status.toLowerCase().trim();
            final matchesStatus =
                _selectedStatuses.isEmpty ||
                _selectedStatuses.any((s) => s.toLowerCase() == jobStatus);

            final jobTypes = j.type
                .split(RegExp(r'[•,;]'))
                .map((t) => t.trim().toLowerCase())
                .toList();
            final matchesType =
                _selectedTypes.isEmpty ||
                _selectedTypes.any((t) => jobTypes.contains(t.toLowerCase()));

            return matchesStatus && matchesType;
          }).toList();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Column(
                children: [
                  _buildFilterBar(isAr),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        ...filteredJobs.map((j) {
                          final count = RecruitmentSyncStore
                              .instance
                              .applications
                              .where((a) => a.jobId == j.id)
                              .length;
                          final isOpen =
                              j.status.toLowerCase().trim() == 'open';

                          const cardColor = Color(0xFF213E75);
                          return Card(
                            color: cardColor,
                            elevation: 4,
                            shadowColor: Colors.black.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                final jobArg = Job(
                                  id: j.id,
                                  title: j.title,
                                  companyName: j.companyName,
                                  location: j.location,
                                  employmentType: j.type,
                                  category: j.category,
                                  salaryRange: j.salaryRange,
                                  description: j.description,
                                  responsibilities: j.responsibilities,
                                  niceToHaves: j.niceToHaves,
                                  qualifications: j.qualifications,
                                  benefits: j.benefits
                                      .map(
                                        (b) => JobBenefit(
                                          title: b,
                                          description: '',
                                        ),
                                      )
                                      .toList(),
                                  tags: j.tags,
                                  appliedCount: count,
                                  requiredCount: j.capacity,
                                  acceptedCount: j.acceptedCount,
                                  status: j.status,
                                  createdAt: j.publishedAt,
                                );
                                Navigator.of(context).pushNamed(
                                  AppRoutes.companyJobDetails,
                                  arguments: jobArg,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.business,
                                          size: 16,
                                          color: Colors.white60,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            j.companyName,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            j.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                        if (isOpen)
                                          PopupMenuButton<String>(
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.white70,
                                            ),
                                            onSelected: (val) async {
                                              if (val == 'close') {
                                                try {
                                                  await RecruitmentSyncService
                                                      .instance
                                                      .updateJob(
                                                        jobId: j.id,
                                                        title: j.title,
                                                        companyName:
                                                            j.companyName,
                                                        location: j.location,
                                                        salaryRange:
                                                            j.salaryRange,
                                                        type: j.type,
                                                        description:
                                                            j.description,
                                                        responsibilities:
                                                            j.responsibilities,
                                                        qualifications:
                                                            j.qualifications,
                                                        niceToHaves:
                                                            j.niceToHaves,
                                                        benefits: j.benefits,
                                                        category: j.category,
                                                        tags: j.tags,
                                                        requiredCount:
                                                            j.capacity,
                                                        status: 'Closed',
                                                      );
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          isAr
                                                              ? 'تم إغلاق الوظيفة'
                                                              : 'Job closed',
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                } catch (e) {
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Error closing job: $e',
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 'close',
                                                child: Text(
                                                  isAr ? 'إغلاق' : 'Close',
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: j.type
                                          .split(RegExp(r'[•,;]'))
                                          .map((t) {
                                            final type = t.trim();
                                            if (type.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            final color = _getJobTypeColor(
                                              type,
                                            );
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: color,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: color.withOpacity(
                                                      0.3,
                                                    ),
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
                                          })
                                          .toList(),
                                    ),
                                    if (j.category.isNotEmpty &&
                                        j.category != 'General') ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getCategoryColor(j.category),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          j.category,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: (j.tags)
                                          .map(
                                            (String tag) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceContainerHighest
                                                    .withOpacity(0.15),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                ),
                                              ),
                                              child: Text(
                                                tag,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.people_outline,
                                          size: 16,
                                          color: Colors.cyanAccent,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '$count ${isAr ? 'متقدمين' : 'applicants'}',
                                          style: const TextStyle(
                                            color: Colors.cyanAccent,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (j.capacity > 0)
                                          Text(
                                            isAr
                                                ? 'تم القبول: ${j.acceptedCount} / المطلوب: ${j.capacity}'
                                                : 'Accepted: ${j.acceptedCount} / Required: ${j.capacity}',
                                            style: TextStyle(
                                              color:
                                                  j.acceptedCount >= j.capacity
                                                  ? Colors.greenAccent
                                                  : Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        if (j.location.isNotEmpty) ...[
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 16,
                                            color: Colors.white60,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            j.location,
                                            style: const TextStyle(
                                              color: Colors.white60,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isOpen
                                                ? Colors.greenAccent
                                                      .withOpacity(0.2)
                                                : Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            isOpen
                                                ? (isAr ? 'مفتوح' : 'Open')
                                                : (isAr ? 'مغلق' : 'Closed'),
                                            style: TextStyle(
                                              color: isOpen
                                                  ? Colors.greenAccent
                                                  : Colors.white70,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        if (filteredJobs.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Center(
                              child: Text(
                                t.noJobsYet,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterBar(bool isAr) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _FilterChip(
            label: isAr ? 'مفتوح' : 'Open',
            isSelected: _selectedStatuses.contains('Open'),
            onChanged: (val) => _toggleFilter(_selectedStatuses, 'Open', val),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: isAr ? 'مغلق' : 'Closed',
            isSelected: _selectedStatuses.contains('Closed'),
            onChanged: (val) => _toggleFilter(_selectedStatuses, 'Closed', val),
          ),
          Container(
            height: 24,
            width: 1,
            color: Colors.grey.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          _FilterChip(
            label: isAr ? 'دوام كامل' : 'Full-Time',
            isSelected: _selectedTypes.contains('Full-Time'),
            onChanged: (val) => _toggleFilter(_selectedTypes, 'Full-Time', val),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: isAr ? 'دوام جزئي' : 'Part-Time',
            isSelected: _selectedTypes.contains('Part-Time'),
            onChanged: (val) => _toggleFilter(_selectedTypes, 'Part-Time', val),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: isAr ? 'عمل حر (Freelance)' : 'Freelance',
            isSelected: _selectedTypes.contains('Freelance'),
            onChanged: (val) => _toggleFilter(_selectedTypes, 'Freelance', val),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: isAr ? 'تدريب (Internship)' : 'Internship',
            isSelected: _selectedTypes.contains('Internship'),
            onChanged: (val) =>
                _toggleFilter(_selectedTypes, 'Internship', val),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: isAr ? 'عمل لمرة واحدة' : 'One-time',
            isSelected: _selectedTypes.contains('One-time'),
            onChanged: (val) => _toggleFilter(_selectedTypes, 'One-time', val),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: isAr ? 'عن بعد (Remote)' : 'Remote',
            isSelected: _selectedTypes.contains('Remote'),
            onChanged: (val) => _toggleFilter(_selectedTypes, 'Remote', val),
          ),
        ],
      ),
    );
  }

  void _toggleFilter(Set<String> set, String value, bool? selected) {
    setState(() {
      if (selected == true) {
        set.add(value);
      } else {
        set.remove(value);
      }
    });
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onChanged,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
              : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: isSelected,
                onChanged: onChanged,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(color: Colors.grey.withOpacity(0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _JobHelpers on _CompanyJobsHubScreenState {
  Color _getJobTypeColor(String type) {
    switch (type.toLowerCase().trim()) {
      case 'full-time':
      case 'دوام كامل':
        return Colors.green;
      case 'part-time':
      case 'دوام جزئي':
        return Colors.blue;
      case 'remote':
      case 'عن بعد':
        return Colors.purple;
      case 'freelance':
      case 'عمل حر':
        return Colors.teal;
      case 'one-time':
      case 'عمل لمرة واحدة':
        return Colors.amber;
      case 'internship':
      case 'تدريب':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'technical':
      case 'تقني':
        return const Color(0xFF3B82F6);
      case 'non-technical':
      case 'غير تقني':
        return const Color(0xFFEC4899);
      case 'services':
      case 'خدمات':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF6B7280);
    }
  }
}
