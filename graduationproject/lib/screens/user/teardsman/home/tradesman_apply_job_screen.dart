import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'package:graduationproject/shared/widgets/app_button.dart';
import 'package:graduationproject/shared/services/recruitment_sync_service.dart';

class TradesmanApplyJobScreen extends StatefulWidget {
  const TradesmanApplyJobScreen({super.key, required this.job});

  final RecruitmentJob job;

  @override
  State<TradesmanApplyJobScreen> createState() => _TradesmanApplyJobScreenState();
}

class _TradesmanApplyJobScreenState extends State<TradesmanApplyJobScreen> {
  final _coverLetterController = TextEditingController();
  final _priceController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _coverLetterController.dispose();
    _priceController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          'assets/company/logo/لوجو جديد.png',
          height: 50,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Job Header Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.job.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                ),
                if (widget.job.companyName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.job.companyName,
                    style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          _buildTextField(
            context,
            t.tr(en: 'Cover Letter', ar: 'خطاب التقديم'), 
            _coverLetterController, 
            Icons.description_outlined, 
            maxLines: 5,
            hint: t.tr(en: 'Explain why you are the best fit...', ar: 'اشرح لماذا أنت الأنسب لهذه الوظيفة...')
          ),
          
          const SizedBox(height: 24),
          AppButton(
            label: t.tr(en: 'Submit Application', ar: 'إرسال الطلب'),
            loading: _loading,
            backgroundColor: const Color(0xFF142C66),
            onPressed: () async {
              if (_coverLetterController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.tr(en: 'Please fill all fields', ar: 'يرجى ملء جميع الحقول'))),
                );
                return;
              }

              setState(() => _loading = true);
              try {
                // Real API Call
                await RecruitmentSyncService.instance.applyToJob(
                  jobId: widget.job.id,
                  userName: store.currentUserName,
                );

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.tr(en: 'Application Sent!', ar: 'تم إرسال الطلب بنجاح!'))),
                );
                Navigator.pop(context);
              } catch (e) {
                if (!mounted) return;
                setState(() => _loading = false);
                
                String errorMsg = e.toString().contains('already applied') 
                    ? t.tr(en: 'You have already applied for this job', ar: 'لقد قمت بالتقديم لهذه الوظيفة بالفعل')
                    : t.tr(en: 'Failed to send application', ar: 'فشل إرسال الطلب');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMsg)),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label, 
    TextEditingController controller, 
    IconData icon, 
    {TextInputType? keyboardType, int maxLines = 1, String? hint}
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
          hintText: hint,
          hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 13),
          prefixIcon: Icon(icon, color: colorScheme.primary, size: 20),
          filled: true,
          fillColor: theme.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
