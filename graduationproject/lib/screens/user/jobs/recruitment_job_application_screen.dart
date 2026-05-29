import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/utils/job_category_helper.dart';
import '../../../shared/widgets/app_button.dart';

class RecruitmentJobApplicationScreen extends StatefulWidget {
  const RecruitmentJobApplicationScreen({super.key, required this.job});

  final RecruitmentJob job;

  @override
  State<RecruitmentJobApplicationScreen> createState() =>
      _RecruitmentJobApplicationScreenState();
}

class _RecruitmentJobApplicationScreenState
    extends State<RecruitmentJobApplicationScreen> {
  final _portfolio = TextEditingController();
  final _cover = TextEditingController();
  final _linkedIn = TextEditingController();
  final _problemDescription = TextEditingController();
  final _addressDetail = TextEditingController();

  bool _loading = false;
  String? _selectedCVName;
  String? _governorate;
  String? _district;

  bool get _isServiceJob => isTradesmanServiceJob(widget.job);

  @override
  void dispose() {
    _portfolio.dispose();
    _cover.dispose();
    _linkedIn.dispose();
    _problemDescription.dispose();
    _addressDetail.dispose();
    super.dispose();
  }

  Future<void> _pickCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _selectedCVName = result.files.single.name;
      });
    }
  }

  String? _buildFullAddress() {
    final parts = <String>[
      if (_governorate != null && _governorate!.isNotEmpty) _governorate!,
      if (_district != null && _district!.isNotEmpty) _district!,
      if (_addressDetail.text.trim().isNotEmpty) _addressDetail.text.trim(),
    ];
    if (parts.isEmpty) return null;
    return parts.join(' - ');
  }

  Future<void> _submit(bool isAr) async {
    final store = RecruitmentSyncStore.instance;

    if (_isServiceJob) {
      final address = _buildFullAddress();
      if (address == null || _problemDescription.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isAr
                  ? 'يرجى إدخال العنوان ووصف المشكلة.'
                  : 'Please enter your address and problem description.',
            ),
          ),
        );
        return;
      }

      setState(() => _loading = true);
      try {
        await RecruitmentSyncService.instance.applyToJob(
          jobId: widget.job.id,
          userName: store.currentUserName,
        );
        store.applyToJob(
          widget.job,
          about: _problemDescription.text.trim(),
          location: address,
        );
        if (!mounted) return;
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isAr ? 'تم إرسال طلب الخدمة بنجاح.' : 'Service request sent successfully.',
            ),
          ),
        );
        Navigator.of(context).pop();
      } catch (_) {
        store.applyToJob(
          widget.job,
          about: _problemDescription.text.trim(),
          location: address,
        );
        if (!mounted) return;
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isAr ? 'تم حفظ طلبك محلياً.' : 'Your request was saved locally.',
            ),
          ),
        );
        Navigator.of(context).pop();
      }
      return;
    }

    if (_cover.text.trim().isEmpty || _selectedCVName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr
                ? 'يرجى رفع السيرة الذاتية وكتابة خطاب التغطية.'
                : 'Please upload your CV and write a cover letter.',
          ),
        ),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await RecruitmentSyncService.instance.applyToJob(
        jobId: widget.job.id,
        userName: store.currentUserName,
      );
      store.applyToJob(widget.job, hasCv: true);
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr ? 'تم تقديم الطلب بنجاح.' : 'Application submitted successfully.',
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (_) {
      store.applyToJob(widget.job, hasCv: true);
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr ? 'تم حفظ طلبك محلياً.' : 'Your application was saved locally.',
          ),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);
    final areas = _governorate == null
        ? <String>[]
        : RecruitmentSyncStore.tradesmanGovernorateAreas[_governorate] ?? [];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          _isServiceJob
              ? (isAr ? 'طلب خدمة' : 'Request service')
              : (isAr ? 'التقديم للوظيفة' : 'Apply to job'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildJobHeader(theme),
          const SizedBox(height: 24),
          if (_isServiceJob) ...[
            Text(
              isAr ? 'تفاصيل الطلب' : 'Request details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isAr
                  ? 'أدخل عنوانك ووصف المشكلة ليصله الصنايعي.'
                  : 'Enter your address and describe the problem for the tradesman.',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: isAr ? 'المحافظة' : 'Governorate',
              value: _governorate,
              hint: isAr ? 'اختر المحافظة' : 'Select governorate',
              items: RecruitmentSyncStore.tradesmanGovernorateAreas.keys
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() {
                _governorate = v;
                _district = null;
              }),
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              label: isAr ? 'المنطقة' : 'Area',
              value: _district,
              hint: isAr ? 'اختر المنطقة' : 'Select area',
              items: areas
                  .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                  .toList(),
              onChanged: (v) => setState(() => _district = v),
            ),
            const SizedBox(height: 12),
            _buildInputField(
              isAr ? 'تفاصيل العنوان' : 'Address details',
              _addressDetail,
              hint: isAr ? 'الشارع، المبنى، رقم الشقة...' : 'Street, building, apartment...',
            ),
            const SizedBox(height: 12),
            _buildInputField(
              isAr ? 'وصف المشكلة' : 'Problem description',
              _problemDescription,
              maxLines: 5,
              hint: isAr
                  ? 'اشرح المشكلة التي تحتاج حلها بالتفصيل'
                  : 'Describe the problem you need help with',
            ),
          ] else ...[
            _buildInputField(
              isAr ? 'رابط معرض الأعمال (Portfolio)' : 'Portfolio URL',
              _portfolio,
            ),
            _buildInputField(
              isAr ? 'رابط LinkedIn' : 'LinkedIn URL',
              _linkedIn,
            ),
            const SizedBox(height: 8),
            Text(
              isAr ? 'السيرة الذاتية (CV)' : 'Curriculum Vitae (CV)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickCV,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedCVName ??
                            (isAr
                                ? 'ارفع سيرتك الذاتية (PDF, DOC)'
                                : 'Upload your CV (PDF, DOC)'),
                        style: TextStyle(
                          color: _selectedCVName == null
                              ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInputField(
              isAr ? 'خطاب التغطية' : 'Cover letter',
              _cover,
              maxLines: 5,
            ),
          ],
          const SizedBox(height: 24),
          AppButton(
            label: _isServiceJob
                ? (isAr ? 'إرسال الطلب' : 'Send request')
                : (isAr ? 'تقديم الطلب' : 'Submit application'),
            loading: _loading,
            backgroundColor: const Color(0xFF4A6ED1),
            onPressed: _loading ? null : () => _submit(isAr),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildJobHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.job.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.job.companyName,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          if (_isServiceJob) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.handyman_outlined,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? 'طلب خدمة من صنايعي'
                      : 'Tradesman service request',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: items,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
