// Tabular list of applicants for a job.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../app/router/app_router.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/models/applicant.dart';
import '../../../shared/models/job.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../widgets/company_app_bar_actions.dart';
import '../widgets/company_bottom_nav.dart';

class CompanyJobApplicantsTableViewScreen extends StatefulWidget {
  const CompanyJobApplicantsTableViewScreen({super.key, required this.job});

  final Job job;

  @override
  State<CompanyJobApplicantsTableViewScreen> createState() =>
      _CompanyJobApplicantsTableViewScreenState();
}

class _CompanyJobApplicantsTableViewScreenState
    extends State<CompanyJobApplicantsTableViewScreen> {
  final _searchController = TextEditingController();
  final ApiClient _apiClient = ApiClient();

  List<Applicant> _applicants = [];
  bool _isLoading = true;
  String? _errorMessage;

  // ✅ تتبع المتقدمين الذين يتم تحديث حالتهم
  final Set<String> _updatingApplicants = {};

  static List<String> _getStageOptions(AppLocalizations t) => [
    t.isAr ? 'تم التقديم' : 'Applied',
    t.isAr ? 'قيد المراجعة' : 'In Review',
    t.isAr ? 'مختصر' : 'Shortlisted',
    t.isAr ? 'قائمة الانتظار' : 'Waitlist',
    t.isAr ? 'تم التوظيف' : 'Hired',
    t.isAr ? 'مرفوض' : 'Declined',
  ];

  late Set<String> _selectedStages;

  @override
  void initState() {
    super.initState();
    _selectedStages = {
      'Applied',
      'In Review',
      'Shortlisted',
      'Waitlist',
      'Hired',
      'Declined',
      'Pending',
      'Accepted',
      'Rejected',
    };
    _fetchApplicants();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// ✅ تحديث حالة المتقدم عبر الـ API
  Future<void> _updateApplicationStatus({
    required String applicationId,
    required String newStatus,
  }) async {
    // ✅ إضافة المتقدم للقائمة اللي بتتحدث
    setState(() {
      _updatingApplicants.add(applicationId);
    });

    try {
      if (kDebugMode) {
        debugPrint('🔄 Updating application $applicationId to $newStatus');
      }

      // ✅ إرسال الطلب للـ API
      final response = await _apiClient.patch(
        '${ApiConstants.applications}/$applicationId/status',
        data: {'status': newStatus.toLowerCase()},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ تحديث القائمة المحلية
        setState(() {
          final index = _applicants.indexWhere((a) => a.id == applicationId);
          if (index != -1) {
            final old = _applicants[index];
            _applicants[index] = Applicant(
              id: old.id,
              fullName: old.fullName,
              role: old.role,
              rating: old.rating,
              stage: _normalizeStatus(newStatus),
              email: old.email,
              phone: old.phone,
              location: old.location,
              appliedDateLabel: old.appliedDateLabel,
              gender: old.gender,
              birthDate: old.birthDate,
              languages: old.languages,
              about: old.about,
              experienceYears: old.experienceYears,
              education: old.education,
              skills: old.skills,
              hasCv: old.hasCv,
              jobId: old.jobId,
              avatarUrl: old.avatarUrl,
            );
          }
          _updatingApplicants.remove(applicationId);
        });

        // ✅ رسالة نجاح
        if (mounted) {
          final t = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _getStatusMessage(newStatus, t.isAr),
              ),
              backgroundColor: _getStatusColor(newStatus),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        if (kDebugMode) {
          debugPrint('✅ Successfully updated to $newStatus');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error updating status: $e');
      }

      setState(() {
        _updatingApplicants.remove(applicationId);
      });

      if (mounted) {
        final t = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.isAr ? 'فشل في تحديث الحالة: $e' : 'Failed to update status: $e',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ✅ رسالة الحالة
  String _getStatusMessage(String status, bool isAr) {
    switch (status.toLowerCase()) {
      case 'hired':
      case 'accepted':
        return isAr ? 'تم قبول المتقدم بنجاح' : 'Applicant accepted successfully';
      case 'declined':
      case 'rejected':
        return isAr ? 'تم رفض المتقدم' : 'Applicant declined';
      case 'waitlist':
        return isAr ? 'تم إضافة المتقدم لقائمة الانتظار' : 'Added to waitlist';
      default:
        return isAr ? 'تم تحديث الحالة' : 'Status updated';
    }
  }

  // ✅ لون الحالة
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hired':
      case 'accepted':
        return Colors.green;
      case 'declined':
      case 'rejected':
        return Colors.red;
      case 'waitlist':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  // ✅ Dialog للتأكيد
  void _showStatusDialog({
    required Applicant applicant,
    required String newStatus,
  }) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;

    String title, message;
    Color color;

    switch (newStatus.toLowerCase()) {
      case 'hired':
      case 'accepted':
        title = isAr ? 'تأكيد القبول' : 'Confirm Acceptance';
        message = isAr
            ? 'هل أنت متأكد من قبول ${applicant.fullName}؟'
            : 'Are you sure you want to accept ${applicant.fullName}?';
        color = Colors.green;
        break;
      case 'declined':
      case 'rejected':
        title = isAr ? 'تأكيد الرفض' : 'Confirm Rejection';
        message = isAr
            ? 'هل أنت متأكد من رفض ${applicant.fullName}؟'
            : 'Are you sure you want to decline ${applicant.fullName}?';
        color = Colors.red;
        break;
      case 'waitlist':
        title = isAr ? 'تأكيد الانتظار' : 'Confirm Waitlist';
        message = isAr
            ? 'هل تريد إضافة ${applicant.fullName} لقائمة الانتظار؟'
            : 'Add ${applicant.fullName} to waitlist?';
        color = Colors.orange;
        break;
      default:
        return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: color),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isAr ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _updateApplicationStatus(
                applicationId: applicant.id,
                newStatus: newStatus,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            child: Text(isAr ? 'تأكيد' : 'Confirm'),
          ),
        ],
      ),
    );
  }

  /// ✅ جلب المتقدمين للوظيفة من الـ API
  Future<void> _fetchApplicants() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (kDebugMode) {
        debugPrint('🔍 Fetching applicants for job ID: ${widget.job.id}');
      }

      final response = await _apiClient.get(
        '${ApiConstants.applications}/job/${widget.job.id}',
      );

      final data = response.data;
      List<dynamic> applicantsList = [];

      if (data is Map && data['data'] is List) {
        applicantsList = data['data'] as List;
      } else if (data is List) {
        applicantsList = data;
      } else if (data is Map) {
        applicantsList = [data];
      }

      if (kDebugMode) {
        debugPrint('✅ Fetched ${applicantsList.length} applicants');
        if (applicantsList.isNotEmpty) {
          debugPrint('📋 First applicant: ${applicantsList[0]}');
        }
      }

      if (applicantsList.isEmpty) {
        setState(() {
          _applicants = [];
          _isLoading = false;
          _errorMessage = null;
        });
        return;
      }

      final applicants = applicantsList
          .map((app) {
        if (app is! Map) return null;

        final user = app['user'] is Map ? app['user'] as Map : {};

        // ✅ استخراج avatarUrl ومعالجته
        String? avatarUrl = user['avatarUrl']?.toString();
        if (avatarUrl != null && avatarUrl.isNotEmpty) {
          if (!avatarUrl.startsWith('http')) {
            avatarUrl = '${ApiConstants.baseUrl}$avatarUrl';
          }
        }

        return Applicant(
          id: app['applicationId']?.toString() ?? app['id']?.toString() ?? '',
          fullName: user['fullName']?.toString() ?? 'Unknown',
          role: app['job']?['title']?.toString() ?? widget.job.title,
          rating: 4.5,
          stage: _normalizeStatus(app['status']?.toString()),
          email: user['email']?.toString() ?? '',
          phone: user['phone']?.toString() ?? '',
          location: user['location']?.toString() ?? 'Egypt',
          appliedDateLabel: _formatDate(app['appliedAt']?.toString()),
          gender: user['gender']?.toString(),
          birthDate: user['birthDate']?.toString(),
          languages: user['languages'] is List
              ? List<String>.from(user['languages'])
              : [],
          about: user['bio']?.toString() ?? user['about']?.toString(),
          experienceYears: user['experienceYears'] is int
              ? user['experienceYears'] as int
              : 0,
          education: user['education']?.toString(),
          skills: user['skills'] is List
              ? List<String>.from(user['skills'])
              : [],
          hasCv: app['resumeUrl'] != null &&
              app['resumeUrl'].toString().isNotEmpty,
          jobId: widget.job.id,
          avatarUrl: avatarUrl,
        );
      })
          .where((a) => a != null)
          .cast<Applicant>()
          .toList();

      setState(() {
        _applicants = applicants;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error fetching applicants: $e');
      }

      String errorMessage;
      if (e.toString().contains('403')) {
        errorMessage = 'ليس لديك صلاحية لعرض المتقدمين';
      } else if (e.toString().contains('404')) {
        errorMessage = 'الوظيفة غير موجودة';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'انتهت مهلة الاتصال';
      } else {
        errorMessage = 'حدث خطأ في تحميل المتقدمين';
      }

      setState(() {
        _applicants = [];
        _isLoading = false;
        _errorMessage = errorMessage;
      });
    }
  }

  String _normalizeStatus(String? status) {
    if (status == null || status.isEmpty) return 'Applied';
    final lower = status.toLowerCase();

    if (lower == 'applied' || lower == 'pending') return 'Applied';
    if (lower == 'reviewing' || lower == 'in review') return 'In Review';
    if (lower == 'shortlisted' || lower == 'shortlist') return 'Shortlisted';
    if (lower == 'waitlist' || lower == 'wait list') return 'Waitlist';
    if (lower == 'hired' || lower == 'accepted') return 'Hired';
    if (lower == 'declined' || lower == 'rejected') return 'Declined';

    if (status.isNotEmpty) {
      return status[0].toUpperCase() + status.substring(1).toLowerCase();
    }
    return 'Applied';
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Today';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) return 'Today';
      if (diff.inDays == 1) return 'Yesterday';
      if (diff.inDays < 7) return '${diff.inDays} days ago';
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Today';
    }
  }

  bool _matchesSearch(Applicant a) {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return true;
    return a.fullName.toLowerCase().contains(q) ||
        a.role.toLowerCase().contains(q) ||
        a.email.toLowerCase().contains(q);
  }

  bool _matchesStages(Applicant a) {
    return _selectedStages.contains(a.stage);
  }

  Future<void> _openFilterSheet() async {
    final t = AppLocalizations.of(context);
    final stages = _getStageOptions(t);

    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        final temp = _selectedStages.toSet();
        return StatefulBuilder(
          builder: (ctx, setInnerState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t.isAr ? 'تصفية' : 'Filter',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...stages.map((s) {
                      final internalStatus = _mapLocalizedStatusToInternal(s, t);
                      return CheckboxListTile(
                        dense: true,
                        value: temp.contains(internalStatus),
                        onChanged: (v) {
                          setInnerState(() {
                            if (v == true) {
                              temp.add(internalStatus);
                            } else {
                              temp.remove(internalStatus);
                            }
                          });
                        },
                        title: Text(s),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      );
                    }),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(ctx).pop({
                              'Applied', 'In Review', 'Shortlisted',
                              'Waitlist', 'Hired', 'Declined',
                              'Pending', 'Accepted', 'Rejected',
                            }),
                            child: Text(t.isAr ? 'إعادة تعيين' : 'Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () => Navigator.of(ctx).pop(temp),
                            child: Text(t.isAr ? 'تطبيق' : 'Apply'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null) return;
    setState(() => _selectedStages = result);
  }

  String _mapLocalizedStatusToInternal(String localized, AppLocalizations t) {
    if (localized == (t.isAr ? 'تم التقديم' : 'Applied')) return 'Applied';
    if (localized == (t.isAr ? 'قيد المراجعة' : 'In Review')) return 'In Review';
    if (localized == (t.isAr ? 'مختصر' : 'Shortlisted')) return 'Shortlisted';
    if (localized == (t.isAr ? 'قائمة الانتظار' : 'Waitlist')) return 'Waitlist';
    if (localized == (t.isAr ? 'تم التوظيف' : 'Hired')) return 'Hired';
    if (localized == (t.isAr ? 'مرفوض' : 'Declined')) return 'Declined';
    return localized;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    final filtered = _applicants
        .where((a) => _matchesStages(a) && _matchesSearch(a))
        .toList();

    return AppScaffold(
      title: widget.job.title,
      showBack: false,
      leading: const CompanyProfileLeading(),
      actions: [
        CompanyAppBarActions(),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _fetchApplicants,
          tooltip: t.isAr ? 'تحديث' : 'Refresh',
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 420;
                if (isNarrow) {
                  return Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: t.isAr ? 'البحث في المتقدمين' : 'Search applicants',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _openFilterSheet,
                          icon: const Icon(Icons.filter_list),
                          label: Text(t.isAr ? 'تصفية' : 'Filter'),
                        ),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: t.isAr ? 'البحث في المتقدمين' : 'Search applicants',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _openFilterSheet,
                      icon: const Icon(Icons.filter_list),
                      label: Text(t.isAr ? 'تصفية' : 'Filter'),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage != null
                        ? _errorMessage!
                        : (t.isAr ? 'لا يوجد متقدمين' : 'No applicants'),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _fetchApplicants,
                      icon: const Icon(Icons.refresh),
                      label: Text(t.isAr ? 'إعادة المحاولة' : 'Retry'),
                    ),
                  ],
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final a = filtered[i];
                final isUpdating = _updatingApplicants.contains(a.id);

                return _ApplicantRow(
                  applicant: a,
                  isUpdating: isUpdating,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.companyApplicantDetailsProfile,
                      arguments: a,
                    );
                  },
                  onAccept: () => _showStatusDialog(
                    applicant: a,
                    newStatus: 'Hired',
                  ),
                  onReject: () => _showStatusDialog(
                    applicant: a,
                    newStatus: 'Declined',
                  ),
                  onWait: () => _showStatusDialog(
                    applicant: a,
                    newStatus: 'Waitlist',
                  ),
                  avatarIndex: i,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CompanyBottomNav(
        current: CompanyTab.applicants,
      ),
    );
  }
}

class _ApplicantRow extends StatelessWidget {
  const _ApplicantRow({
    required this.applicant,
    required this.isUpdating,
    required this.onTap,
    required this.onAccept,
    required this.onReject,
    required this.onWait,
    required this.avatarIndex,
  });

  final Applicant applicant;
  final bool isUpdating;
  final VoidCallback onTap;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onWait;
  final int avatarIndex;

  String _getInitial(String name) {
    if (name.isEmpty) return '?';
    return name[0].toUpperCase();
  }

  Color _stageColor(BuildContext context) {
    final stage = applicant.stage.toLowerCase();
    if (stage.contains('declin') || stage.contains('reject'))
      return Theme.of(context).colorScheme.error;
    if (stage.contains('hire') || stage.contains('accept'))
      return Colors.tealAccent.shade700;
    if (stage.contains('review')) return Colors.orange;
    if (stage.contains('shortlist')) return Colors.blue;
    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;
    final chipColor = _stageColor(context);

    final bool hasProfileImage = applicant.avatarUrl != null &&
        applicant.avatarUrl!.isNotEmpty;

    // ✅ هل الحالة نهائية (مقبول/مرفوض/انتظار)؟
    final isFinal = applicant.stage.toLowerCase().contains('hire') ||
        applicant.stage.toLowerCase().contains('accept') ||
        applicant.stage.toLowerCase().contains('declin') ||
        applicant.stage.toLowerCase().contains('reject') ||
        applicant.stage.toLowerCase().contains('wait');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isUpdating ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ✅ الصف الرئيسي
              Row(
                children: [
                  // ✅ الصورة أو الحرف الأول
                  CircleAvatar(
                    backgroundColor: hasProfileImage
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.primary,
                    backgroundImage: hasProfileImage
                        ? NetworkImage(applicant.avatarUrl!)
                        : null,
                    child: hasProfileImage
                        ? null
                        : Text(
                      _getInitial(applicant.fullName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applicant.fullName.isNotEmpty ? applicant.fullName : 'Unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${applicant.appliedDateLabel} • ⭐ ${applicant.rating.toStringAsFixed(1)}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        if (applicant.email.isNotEmpty)
                          Text(
                            applicant.email,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // ✅ شارة الحالة
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: chipColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: chipColor.withOpacity(0.35)),
                    ),
                    child: isUpdating
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      _translateStatus(applicant.stage, isAr),
                      style: TextStyle(
                        color: chipColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // ✅ أزرار الإجراءات (لو الحالة مش نهائية)
              if (!isFinal && !isUpdating) ...[
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: isAr ? 'انتظار' : 'Wait',
                        color: Colors.amber,
                        icon: Icons.hourglass_empty,
                        onTap: onWait,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ActionButton(
                        label: isAr ? 'رفض' : 'Reject',
                        color: Colors.red,
                        icon: Icons.close,
                        onTap: onReject,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ActionButton(
                        label: isAr ? 'قبول' : 'Accept',
                        color: Colors.green,
                        icon: Icons.check,
                        onTap: onAccept,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _translateStatus(String status, bool isAr) {
    if (!isAr) return status;
    final low = status.toLowerCase();
    if (low.contains('hire') || low.contains('accept')) return 'تم القبول';
    if (low.contains('reject') || low.contains('declin')) return 'تم الرفض';
    if (low.contains('wait')) return 'قائمة الانتظار';
    if (low.contains('review')) return 'قيد المراجعة';
    if (low.contains('short')) return 'مختصر';
    return 'تم التقديم';
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}