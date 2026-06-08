import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graduationproject/screens/company/widgets/company_applicant_avatar.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/services/recruitment_sync_service.dart';
import 'package:graduationproject/shared/services/job_service.dart';
import 'package:graduationproject/shared/services/application_service.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'tradesman_service_requester_profile_screen.dart';
import '../Tradesman_Messages/chat_tradesman.dart';

class JobApplicantsScreen extends StatefulWidget {
  final String? jobId;
  final String jobTitle;
  final String? initialDesc;
  final String? initialBudget;
  final List<String>? initialDays;
  const JobApplicantsScreen({
    super.key,
    this.jobId,
    required this.jobTitle,
    this.initialDesc,
    this.initialBudget,
    this.initialDays,
  });

  @override
  State<JobApplicantsScreen> createState() => _JobApplicantsScreenState();
}

class _JobApplicantsScreenState extends State<JobApplicantsScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _activeTabIndex = 0; // 0 for Applicants, 1 for Job Details
  bool _isEditing = false;

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _deadlineController;
  late TextEditingController _locationController;
  late TextEditingController _skillInputController;
  late List<String> _selectedDays;
  late List<String> _editableSkills;
  late String _postedDateLabel;
  late String _workStatus;
  RecruitmentJob? _existingJob;

  final List<String> _allDays = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];

  final List<File> _workPhotos = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final store = RecruitmentSyncStore.instance;

    if (widget.jobId != null && widget.jobId!.isNotEmpty) {
      try {
        _existingJob = store.jobs.firstWhere((j) => j.id == widget.jobId);
      } catch (_) {
        _existingJob = null;
      }
    }

    _titleController = TextEditingController(
      text: _existingJob?.title ?? widget.jobTitle,
    );
    _descController = TextEditingController(
      text: _existingJob?.description ?? widget.initialDesc ?? '',
    );
    _locationController = TextEditingController(
      text: _existingJob?.location ?? store.currentUserLocation,
    );
    _skillInputController = TextEditingController();
    _deadlineController = TextEditingController(
      text: DateTime.now()
          .add(const Duration(days: 7))
          .toString()
          .split(' ')[0],
    );
    _selectedDays = List.from(widget.initialDays ?? []);
    _editableSkills = List.from(_existingJob?.tags ?? []);
    _postedDateLabel = _formatDate(
      _existingJob?.publishedAt ?? DateTime.now(),
    );
    final jobId = widget.jobId ?? '';
    final rawStatus = jobId.isEmpty
        ? 'Active'
        : store.tradesmanJobStatus(jobId, _existingJob?.status ?? 'Active');
        
    if (rawStatus.toLowerCase() == 'open' || rawStatus.toLowerCase() == 'active') {
      _workStatus = 'Active';
    } else if (rawStatus.toLowerCase() == 'closed') {
      _workStatus = 'Closed';
    } else if (rawStatus.toLowerCase() == 'inactive') {
      _workStatus = 'Inactive';
    } else {
      _workStatus = 'Active';
    }
        
    if (jobId.isNotEmpty) {
      // Import ApplicationService to fetch applicants for this job
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Safe to call API after first frame
        try {
          _fetchApplicants(jobId);
        } catch (_) {}
      });
    }
  }

  Future<void> _fetchApplicants(String jobId) async {
    try {
      await ApplicationService.instance.getJobApplicants(jobId);
      if (mounted) {
        setState(() {});
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _deadlineController.dispose();
    _locationController.dispose();
    _skillInputController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _getTranslatedDay(String day, AppLocalizations t) {
    switch (day) {
      case "Saturday":
        return t.tr(en: "Saturday", ar: "السبت");
      case "Sunday":
        return t.tr(en: "Sunday", ar: "الأحد");
      case "Monday":
        return t.tr(en: "Monday", ar: "الاثنين");
      case "Tuesday":
        return t.tr(en: "Tuesday", ar: "الثلاثاء");
      case "Wednesday":
        return t.tr(en: "Wednesday", ar: "الأربعاء");
      case "Thursday":
        return t.tr(en: "Thursday", ar: "الخميس");
      case "Friday":
        return t.tr(en: "Friday", ar: "الجمعة");
      default:
        return day;
    }
  }

  Future<void> _pickWorkPhotos() async {
    final images = await _imagePicker.pickMultiImage();
    if (images.isEmpty) return;
    setState(() {
      _workPhotos.addAll(images.map((x) => File(x.path)));
    });
  }

  String _translateApplicantStatus(String status, bool isAr) {
    final low = status.toLowerCase();
    if (isAr) {
      if (low.contains('accept') || low.contains('hire')) return 'مقبول';
      if (low.contains('reject') || low.contains('declin')) return 'مرفوض';
      if (low.contains('pend')) return 'قيد المراجعة';
      if (low.contains('appli')) return 'تم التقديم';
      return status;
    }
    if (low.contains('accept') || low.contains('hire')) return 'Accepted';
    if (low.contains('reject') || low.contains('declin')) return 'Rejected';
    if (low.contains('pend')) return 'Pending';
    if (low.contains('appli')) return 'Applied';
    return status;
  }



  List<RecruitmentApplication> _filterApplicants(
    List<RecruitmentApplication> source,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return source;

    return source.where((app) {
      final haystack = [
        app.userName,
        ...app.skills,
        app.location ?? '',
        app.status,
      ].join(' ').toLowerCase();

      return haystack.contains(query);
    }).toList();
  }

  Future<void> _toggleEdit() async {
    final t = AppLocalizations.of(context);
    if (_isEditing) {
      final jobId = widget.jobId;
      if (jobId != null && jobId.isNotEmpty) {
        try {
          await JobService.instance.updateJob(
            jobId,
            {
              'title': _titleController.text.trim(),
              'location': _locationController.text.trim(),
              'salaryRange': _existingJob?.salaryRange ?? 'Negotiable',
              'description': _descController.text.trim(),
              'responsibilities': _existingJob?.responsibilities ?? [],
              'qualifications': _existingJob?.qualifications ?? [],
              'niceToHaves': _existingJob?.niceToHaves ?? [],
              'benefits': _existingJob?.benefits ?? [],
              'category': _existingJob?.category ?? 'Service',
              'companyName': _existingJob?.companyName ?? RecruitmentSyncStore.instance.currentUserName,
              'type': _existingJob?.type ?? 'one-time',
              'tags': _editableSkills,
              'requiredCount': _existingJob?.capacity ?? 1,
              'status': _workStatus,
            }
          );
          await JobService.instance.getJobs();
          RecruitmentSyncStore.instance.setTradesmanJobStatus(jobId, _workStatus);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${t.tr(en: 'Failed to save changes', ar: 'فشل حفظ التعديلات')}: $e',
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
          return;
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.tr(en: 'Changes saved successfully', ar: 'تم حفظ التعديلات بنجاح'),
            ),
          ),
        );
      }
    }
    if (mounted) {
      setState(() => _isEditing = !_isEditing);
    }
  }

  void _openApplicantProfile(RecruitmentApplication app) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TradesmanServiceRequesterProfileScreen(application: app),
      ),
    );
  }

  Future<bool> _confirmDeleteApplicant(RecruitmentApplication app) async {
    final t = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.tr(en: 'Delete applicant', ar: 'حذف المتقدم')),
        content: Text(
          t.tr(
            en: 'Do you want to remove ${app.userName} from applicants?',
            ar: 'هل تريد حذف ${app.userName} من المتقدمين؟',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.tr(en: 'Cancel', ar: 'إلغاء')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.tr(en: 'Delete', ar: 'حذف')),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      RecruitmentSyncStore.instance.removeApplication(app.id);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.tr(en: 'Applicant removed', ar: 'تم حذف المتقدم')),
        ),
      );
    }
    return confirmed ?? false;
  }

  void _showDeleteDialog() {
    final t = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.tr(en: "Delete Job", ar: "حذف الوظيفة")),
        content: Text(
          t.tr(
            en: "Are you sure you want to permanently delete this post?",
            ar: "هل أنت متأكد من رغبتك في حذف هذا المنشور نهائياً؟",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.tr(en: "Cancel", ar: "إلغاء"),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                if (widget.jobId != null && widget.jobId!.isNotEmpty) {
                  try {
                    await JobService.instance.deleteJob(widget.jobId!);
                  } catch (apiError) {
                    if (apiError.toString().contains('403')) {
                      // Backend forbids deleting tradesman jobs for normal users.
                      // Perform a soft local delete so it disappears from the UI.
                      RecruitmentSyncStore.instance.removeJob(widget.jobId!);
                    } else {
                      rethrow;
                    }
                  }
                  await JobService.instance.getJobs();
                }
                if (!context.mounted) return;
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(t.tr(en: "Job deleted", ar: "تم حذف المنشور")),
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${t.tr(en: "Failed to delete", ar: "فشل الحذف")}: $e'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: Text(
              t.tr(en: "Delete", ar: "حذف"),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = RecruitmentSyncStore.instance;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: store,
      builder: (context, child) {
        final realApplicants = store.applications
            .where((app) => app.jobId == widget.jobId)
            .toList();
        final isDark = theme.brightness == Brightness.dark;
        final bgColor = theme.scaffoldBackgroundColor;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: colorScheme.onSurface,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              if (_activeTabIndex == 1) ...[
                if (_isEditing)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: _showDeleteDialog,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isEditing
                          ? Colors.green.withValues(alpha: 0.1)
                          : theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.1),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isEditing ? Icons.check : Icons.edit_outlined,
                        color: _isEditing
                            ? Colors.green
                            : colorScheme.onSurface,
                        size: 20,
                      ),
                      onPressed: () => _toggleEdit(),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isEditing && _activeTabIndex == 1
                          ? TextField(
                              controller: _titleController,
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: t.tr(en: "Job Title", ar: "عنوان الوظيفة"),
                                hintStyle: TextStyle(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.38,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              _titleController.text.isEmpty
                                  ? t.tr(en: "Untitled", ar: "بدون عنوان")
                                  : _titleController.text,
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                      const SizedBox(height: 8),
                      Text(
                        '${t.tr(en: 'Posted on', ar: 'تاريخ النشر')}: $_postedDateLabel',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.54),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      _buildTab(t.tr(en: "Applicants", ar: "المتقدمين"), 0),
                      const SizedBox(width: 32),
                      _buildTab(t.tr(en: "Work details", ar: "تفاصيل العمل"), 1),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),

                const SizedBox(height: 30),

                _activeTabIndex == 0
                    ? _buildApplicantsView(isAr, t, realApplicants)
                    : _buildJobDetailsView(isAr, t),

                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildApplicantsView(
    bool isAr,
    AppLocalizations t,
    List<RecruitmentApplication> applicants,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filteredApplicants = _filterApplicants(applicants);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 520),
                height: 45,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: t.tr(en: 'Search applicants...', ar: 'البحث في المتقدمين...'),
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface.withValues(alpha: 0.38),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 18,
                      color: colorScheme.onSurface.withValues(alpha: 0.38),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        if (filteredApplicants.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 40,
                    color: colorScheme.onSurface.withValues(alpha: 0.12),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.tr(en: 'No applicants to display', ar: 'لا يوجد متقدمين لعرضهم'),
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.38),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredApplicants.length,
            itemBuilder: (context, index) {
              final app = filteredApplicants[index];
              return _buildApplicantCard(
                app: app,
                isAr: isAr,
                t: t,
                theme: theme,
                colorScheme: colorScheme,
              );
            },
          ),
      ],
    );
  }

  Widget _buildApplicantCard({
    required RecruitmentApplication app,
    required bool isAr,
    required AppLocalizations t,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    final statusColor = app.status.toLowerCase().contains('accept') ||
            app.status.toLowerCase().contains('hire')
        ? Colors.green
        : app.status.toLowerCase().contains('reject') ||
              app.status.toLowerCase().contains('declin')
        ? Colors.red
        : Colors.blue;
    final problemDescription = (app.about ?? '').trim();
    final appliedDate = _formatDate(app.updatedAt);
    final statusLabel = _translateApplicantStatus(app.status, isAr);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Dismissible(
        key: ValueKey(app.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 28),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 28,
          ),
        ),
        confirmDismiss: (_) => _confirmDeleteApplicant(app),
        child: Material(
          color: const Color(0xFF213E75),
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => _openApplicantProfile(app),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF213E75),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CompanyApplicantAvatar(seed: app.id, radius: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          app.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            color: statusColor == Colors.green ? Colors.greenAccent : (statusColor == Colors.red ? Colors.redAccent : Colors.cyanAccent),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    app.jobTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.orangeAccent,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (problemDescription.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.report_problem_outlined,
                          size: 15,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            problemDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(
                                alpha: 0.85,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${t.tr(en: 'Applied on', ar: 'تاريخ التقديم')}: $appliedDate',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.white.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildApplicantActionButton(
                        icon: Icons.phone_outlined,
                        color: Colors.cyanAccent,
                        tooltip: t.tr(en: 'Call', ar: 'اتصال'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${t.tr(en: 'Phone Number:', ar: 'رقم الهاتف:')} ${app.phone ?? 'N/A'}",
                              ),
                            ),
                          );
                        },
                      ),
                      _buildApplicantActionButton(
                        icon: Icons.chat_bubble_outline,
                        color: Colors.orangeAccent,
                        tooltip: t.tr(en: 'Chat', ar: 'المحادثة'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatTradesman(
                                userId: app.userId,
                                name: app.userName,
                                image:
                                    "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg",
                              ),
                            ),
                          );
                        },
                      ),
                      _buildApplicantActionButton(
                        icon: Icons.person_outline,
                        color: Colors.white,
                        tooltip: t.tr(en: 'Details', ar: 'التفاصيل'),
                        onPressed: () => _openApplicantProfile(app),
                      ),
                      _buildApplicantActionButton(
                        icon: Icons.delete_outline,
                        color: Colors.redAccent,
                        tooltip: t.tr(en: 'Delete', ar: 'حذف'),
                        onPressed: () => _confirmDeleteApplicant(app),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobDetailsView(bool isAr, AppLocalizations t) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailSection(
            icon: Icons.title_outlined,
            title: t.tr(en: "Work title", ar: "عنوان العمل"),
            content: _titleController.text,
            controller: _titleController,
            isEditable: true,
          ),
          const SizedBox(height: 24),
          _buildDetailSection(
            icon: Icons.description_outlined,
            title: t.tr(en: "Work description", ar: "وصف العمل"),
            content: _descController.text,
            controller: _descController,
            isMultiLine: true,
          ),
          const SizedBox(height: 24),
          _buildDetailSection(
            icon: Icons.calendar_today_outlined,
            title: t.tr(en: "Posted Date", ar: "تاريخ النشر"),
            content: _postedDateLabel,
            isEditable: false,
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.toggle_on_outlined,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.tr(en: 'Work status', ar: 'حالة العمل'),
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.38),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _isEditing
                        ? DropdownButtonFormField<String>(
                            value: _workStatus,
                            decoration: const InputDecoration(isDense: true),
                            items: [
                              DropdownMenuItem(
                                value: 'Active',
                                child: Text(t.tr(en: 'Active', ar: 'نشط')),
                              ),
                              DropdownMenuItem(
                                value: 'Closed',
                                child: Text(t.tr(en: 'Closed', ar: 'مغلق')),
                              ),
                              DropdownMenuItem(
                                value: 'Inactive',
                                child: Text(t.tr(en: 'Inactive', ar: 'غير نشط')),
                              ),
                            ],
                            onChanged: (v) {
                              if (v != null) setState(() => _workStatus = v);
                            },
                          )
                        : Text(
                            RecruitmentSyncStore.instance
                                .translateTradesmanWorkStatus(_workStatus, isAr),
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildDetailSection(
            icon: Icons.event_available_outlined,
            title: t.tr(en: "Deadline", ar: "تاريخ الانتهاء"),
            content: _deadlineController.text,
            controller: _deadlineController,
            isEditable: true,
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.workspace_premium_outlined,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.tr(en: "Required Skills", ar: "المهارات المطلوبة"),
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.38),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_isEditing) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _skillInputController,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: t.tr(
                                  en: 'Add skill',
                                  ar: 'أضف مهارة',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              final skill = _skillInputController.text.trim();
                              if (skill.isEmpty) return;
                              setState(() {
                                if (!_editableSkills.contains(skill)) {
                                  _editableSkills.add(skill);
                                }
                                _skillInputController.clear();
                              });
                            },
                            icon: const Icon(Icons.add_circle_outline),
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _editableSkills.map((skill) {
                        return InputChip(
                          label: Text(skill),
                          onDeleted: _isEditing
                              ? () => setState(() => _editableSkills.remove(skill))
                              : null,
                          backgroundColor:
                              colorScheme.primary.withValues(alpha: 0.12),
                          labelStyle: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.tr(en: "Location", ar: "الموقع"),
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.38),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _isEditing
                        ? TextField(
                            controller: _locationController,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          )
                        : Text(
                            _locationController.text.trim().isEmpty
                                ? t.tr(en: 'Not specified', ar: 'غير محدد')
                                : _locationController.text.trim(),
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.access_time_outlined,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.tr(en: "Work Time", ar: "وقت العمل"),
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.38),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _isEditing
                        ? Wrap(
                            spacing: 8,
                            children: _allDays.map((day) {
                              bool selected = _selectedDays.contains(day);
                              return FilterChip(
                                label: Text(
                                  _getTranslatedDay(day, t),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                selected: selected,
                                onSelected: (val) {
                                  setState(() {
                                    if (val) {
                                      _selectedDays.add(day);
                                    } else {
                                      _selectedDays.remove(day);
                                    }
                                  });
                                },
                                selectedColor: colorScheme.primary.withValues(
                                  alpha: 0.2,
                                ),
                                checkmarkColor: colorScheme.primary,
                              );
                            }).toList(),
                          )
                        : Text(
                            _selectedDays.isEmpty
                                ? t.tr(en: "None selected", ar: "غير محدد")
                                : _selectedDays
                                    .map((day) => _getTranslatedDay(day, t))
                                    .join(", "),
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t.tr(en: "Work Photos", ar: "صور العمل"),
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.38),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_isEditing)
                    TextButton.icon(
                      onPressed: _pickWorkPhotos,
                      icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
                      label: Text(t.tr(en: 'Add photos', ar: 'إضافة صور')),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (_workPhotos.isEmpty && !_isEditing)
                Text(
                  t.tr(en: 'No photos added', ar: 'لا توجد صور'),
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                    fontSize: 13,
                  ),
                )
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ..._workPhotos.asMap().entries.map((entry) {
                      final index = entry.key;
                      final photo = entry.value;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              photo,
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              top: -6,
                              right: -6,
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _workPhotos.removeAt(index)),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                    if (_isEditing)
                      GestureDetector(
                        onTap: _pickWorkPhotos,
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            color: colorScheme.primary,
                            size: 32,
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection({
    required IconData icon,
    required String title,
    required String content,
    TextEditingController? controller,
    bool isEditable = true,
    bool isMultiLine = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.38),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              _isEditing && isEditable && controller != null
                  ? TextField(
                      controller: controller,
                      maxLines: isMultiLine ? null : 1,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    )
                  : Text(
                      content,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApplicantActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 18),
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: onPressed,
      ),
    );
  }

  Widget _chipPill({
    required String label,
    required Color color,
    required bool isAr,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    bool isActive = _activeTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTabIndex = index;
          if (_activeTabIndex == 0) _isEditing = false;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.45),
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          if (isActive)
            Container(
              height: 3,
              width: 45,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            )
          else
            const SizedBox(height: 3),
        ],
      ),
    );
  }

}
