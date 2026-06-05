import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graduationproject/screens/company/widgets/company_applicant_avatar.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/services/recruitment_sync_service.dart';
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
    _workStatus = jobId.isEmpty
        ? 'Active'
        : store.tradesmanJobStatus(jobId, _existingJob?.status ?? 'Active');
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

  List<RecruitmentApplication> _buildPreviewApplicants() {
    return [
      RecruitmentApplication(
        id: 'preview-1',
        jobId: widget.jobId ?? 'preview-job',
        jobTitle: widget.jobTitle,
        companyName: 'شركة صناعية عربية',
        userName: 'أحمد المصري',
        status: 'Applied',
        updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
        gender: 'ذكر',
        birthDate: '1994-06-12',
        languages: ['العربية', 'الإنجليزية'],
        about: 'عطل في نظام التكييف ويحتاج فحص وصيانة عاجلة.',
        experienceYears: 6,
        education: 'بكالوريوس هندسة ميكانيكية',
        skills: ['النجارة', 'اللحام', 'الصيانة'],
        hasCv: true,
        email: 'ahmed@example.com',
        phone: '01000000000',
        location: 'الجيزة',
      ),
      RecruitmentApplication(
        id: 'preview-2',
        jobId: widget.jobId ?? 'preview-job',
        jobTitle: widget.jobTitle,
        companyName: 'شركة صناعية عربية',
        userName: 'منى حسن',
        status: 'Pending',
        updatedAt: DateTime.now().subtract(const Duration(hours: 9)),
        gender: 'أنثى',
        birthDate: '1998-02-20',
        languages: ['العربية'],
        about: 'تسريب مياه في الحمام والمطبخ يحتاج إصلاح فوري.',
        experienceYears: 4,
        education: 'دبلوم صيانة',
        skills: ['التشطيب', 'التركيب', 'الأعمال اليدوية'],
        hasCv: true,
        email: 'mona@example.com',
        phone: '01111111111',
        location: 'القاهرة',
      ),
      RecruitmentApplication(
        id: 'preview-3',
        jobId: widget.jobId ?? 'preview-job',
        jobTitle: widget.jobTitle,
        companyName: 'شركة صناعية عربية',
        userName: 'يوسف عبد الله',
        status: 'Accepted',
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        gender: 'ذكر',
        birthDate: '1991-11-03',
        languages: ['العربية', 'الفرنسية'],
        about: 'مشكلة كهربائية في لوحة التوزيع مع انقطاع متكرر.',
        experienceYears: 8,
        education: 'بكالوريوس كهرباء',
        skills: ['الكهرباء', 'الصيانة', 'القياس'],
        hasCv: true,
        email: 'yousef@example.com',
        phone: '01222222222',
        location: 'الإسكندرية',
      ),
      RecruitmentApplication(
        id: 'preview-4',
        jobId: widget.jobId ?? 'preview-job',
        jobTitle: widget.jobTitle,
        companyName: 'شركة صناعية عربية',
        userName: 'سارة علي',
        status: 'Pending',
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        gender: 'أنثى',
        birthDate: '1996-08-15',
        languages: ['العربية', 'الإنجليزية'],
        about: 'تركيب شفاط مطبخ جديد مع تمديد الوصلات اللازمة.',
        experienceYears: 3,
        education: 'دبلوم فني صيانة',
        skills: ['الكهرباء', 'التركيب', 'التمديدات'],
        hasCv: false,
        email: 'sara@example.com',
        phone: '01555555555',
        location: 'المنصورة',
      ),
      RecruitmentApplication(
        id: 'preview-5',
        jobId: widget.jobId ?? 'preview-job',
        jobTitle: widget.jobTitle,
        companyName: 'شركة صناعية عربية',
        userName: 'محمد محمود',
        status: 'Applied',
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
        gender: 'ذكر',
        birthDate: '1985-05-22',
        languages: ['العربية'],
        about: 'عزل أسطح ضد المطر والحرارة باستخدام مواد حديثة.',
        experienceYears: 12,
        education: 'فني عزل معتمد',
        skills: ['العزل', 'البناء', 'الترميم'],
        hasCv: true,
        email: 'mohamed@example.com',
        phone: '01011111111',
        location: 'طنطا',
      ),
    ];
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
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    if (_isEditing) {
      final jobId = widget.jobId;
      if (jobId != null && jobId.isNotEmpty) {
        try {
          await RecruitmentSyncService.instance.updateJob(
            jobId: jobId,
            title: _titleController.text.trim(),
            location: _locationController.text.trim(),
            salaryRange: _existingJob?.salaryRange ?? 'Negotiable',
            description: _descController.text.trim(),
            responsibilities: _existingJob?.responsibilities ?? const [],
            qualifications: _existingJob?.qualifications ?? const [],
            niceToHaves: _existingJob?.niceToHaves ?? const [],
            benefits: _existingJob?.benefits ?? const [],
            category: _existingJob?.category ?? 'Service',
            companyName: _existingJob?.companyName ??
                RecruitmentSyncStore.instance.currentUserName,
            type: _existingJob?.type ?? 'one-time',
            tags: _editableSkills,
            requiredCount: _existingJob?.capacity ?? 1,
            status: _workStatus,
          );
          RecruitmentSyncStore.instance.setTradesmanJobStatus(jobId, _workStatus);
        } catch (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isAr ? 'فشل حفظ التعديلات' : 'Failed to save changes',
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
              isAr ? 'تم حفظ التعديلات بنجاح' : 'Changes saved successfully',
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
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAr ? 'حذف المتقدم' : 'Delete applicant'),
        content: Text(
          isAr
              ? 'هل تريد حذف ${app.userName} من المتقدمين؟'
              : 'Do you want to remove ${app.userName} from applicants?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(isAr ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: Text(isAr ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      RecruitmentSyncStore.instance.removeApplication(app.id);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAr ? 'تم حذف المتقدم' : 'Applicant removed'),
        ),
      );
    }
    return confirmed ?? false;
  }

  void _showDeleteDialog() {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAr ? "حذف الوظيفة" : "Delete Job"),
        content: Text(
          isAr
              ? "هل أنت متأكد من رغبتك في حذف هذا المنشور نهائياً؟"
              : "Are you sure you want to permanently delete this post?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              isAr ? "إلغاء" : "Cancel",
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("تم حذف المنشور")));
            },
            child: Text(
              isAr ? "حذف" : "Delete",
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
        final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);

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
                                hintText: "Job Title",
                                hintStyle: TextStyle(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.38,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              _titleController.text.isEmpty
                                  ? (isAr ? "بدون عنوان" : "Untitled")
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
    final demoApplicants = _buildPreviewApplicants();
    final isPreviewMode = applicants.isEmpty;
    final displayApplicants = isPreviewMode ? demoApplicants : applicants;
    final filteredApplicants = _filterApplicants(displayApplicants);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Applicants summary card (UI only)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF213E75),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${filteredApplicants.length}',
                          style: const TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            isAr ? 'متقدم' : 'Applicant',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (isPreviewMode)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'بيانات تجريبية للمعاينة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _chipPill(
                          label: isAr ? 'ملخص' : 'Summary',
                          color: Colors.white,
                          isAr: isAr,
                        ),
                        _chipPill(
                          label: isAr ? 'جاهز للمراجعة' : 'Ready',
                          color: Colors.greenAccent,
                          isAr: isAr,
                        ),
                        _chipPill(
                          label: isAr ? 'حالات متعددة' : 'Multiple',
                          color: Colors.orangeAccent,
                          isAr: isAr,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

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
                    hintText: isAr
                        ? 'البحث في المتقدمين...'
                        : 'Search applicants...',
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
                    isAr
                        ? 'لا يوجد متقدمين لعرضهم'
                        : 'No applicants to display',
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
                        tooltip: isAr ? 'اتصال' : 'Call',
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
                        tooltip: isAr ? 'المحادثة' : 'Chat',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatTradesman(
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
                        tooltip: isAr ? 'التفاصيل' : 'Details',
                        onPressed: () => _openApplicantProfile(app),
                      ),
                      _buildApplicantActionButton(
                        icon: Icons.delete_outline,
                        color: Colors.redAccent,
                        tooltip: isAr ? 'حذف' : 'Delete',
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
                                child: Text(isAr ? 'نشط' : 'Active'),
                              ),
                              DropdownMenuItem(
                                value: 'Closed',
                                child: Text(isAr ? 'مغلق' : 'Closed'),
                              ),
                              DropdownMenuItem(
                                value: 'Inactive',
                                child: Text(isAr ? 'غير نشط' : 'Inactive'),
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
                                ? (isAr ? 'غير محدد' : 'Not specified')
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
                                  day,
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
                                ? (isAr ? "غير محدد" : "None selected")
                                : _selectedDays.join(", "),
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
