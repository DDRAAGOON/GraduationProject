import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/recruitment_sync_store.dart';

class UserHelpCenterScreen extends StatelessWidget {
  const UserHelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF001E3A)
        : const Color(0xFFF8FBF4);
    final onSurfaceColor = isDark ? Colors.white : Colors.black;
    final store = RecruitmentSyncStore.instance;
    final isTradesman = store.userRole == 'Tradesman';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          t.tr(en: 'Help Center', ar: 'مركز المساعدة'),
          style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: onSurfaceColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),
          Text(
            t.tr(en: 'Popular articles', ar: 'المقالات الشائعة'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: onSurfaceColor,
            ),
          ),
          const SizedBox(height: 16),

          // Tradesman specific content
          if (isTradesman) ...[
            _FaqTile(
              title: t.tr(
                en: 'How to add my work to gallery?',
                ar: 'كيف أضيف أعمالي للمعرض؟',
              ),
              body: t.tr(
                en: 'Go to your profile, click on "Edit Profile", and scroll down to the Gallery section to upload your work images.',
                ar: 'انتقل إلى ملفك الشخصي، واضغط على "تعديل الملف الشخصي"، ثم قم بالتمرير لأسفل إلى قسم المعرض لرفع صور أعمالك.',
              ),
              isDark: isDark,
              onSurfaceColor: onSurfaceColor,
            ),
            _FaqTile(
              title: t.tr(
                en: 'How to communicate with customers?',
                ar: 'كيفية التواصل مع العملاء؟',
              ),
              body: t.tr(
                en: 'When a customer contacts you, you will receive a notification and the message will appear in your "Messages" tab.',
                ar: 'عندما يتواصل معك عميل، ستتلقى إشعاراً وستظهر الرسالة في تبويب "الرسائل" الخاص بك.',
              ),
              isDark: isDark,
              onSurfaceColor: onSurfaceColor,
            ),
          ],

          // Common content
          _FaqTile(
            title: t.tr(
              en: 'What is My Applications?',
              ar: 'ما هو قسم "تقديماتي"؟',
            ),
            body: t.tr(
              en: 'My Applications is a way for you to track jobs as you move through the application process...',
              ar: 'قسم تقديماتي هو وسيلة لك لتتبع الوظائف أثناء انتقالك عبر مراحل عملية التقديم المختلفة...',
            ),
            isDark: isDark,
            onSurfaceColor: onSurfaceColor,
          ),
          _FaqTile(
            title: t.tr(
              en: 'How to access my applications history',
              ar: 'كيفية الوصول إلى سجل طلبات التوظيف الخاصة بي',
            ),
            body: t.tr(
              en: 'To access applications history, go to your My Applications page on your dashboard profile...',
              ar: 'للوصول إلى سجل الطلبات، انتقل إلى صفحة تقديماتي في ملفك الشخصي عبر لوحة التحكم الخاصة بك...',
            ),
            isDark: isDark,
            onSurfaceColor: onSurfaceColor,
          ),
          _FaqTile(
            title: t.tr(
              en: 'Not seeing jobs you applied in your my application list?',
              ar: 'لا تظهر الوظائف التي تقدمت إليها في قائمة تقديماتي؟',
            ),
            body: t.tr(
              en: 'Please note that we are unable to track materials submitted for jobs you apply to via an employer’s site...',
              ar: 'يرجى ملاحظة أننا غير قادرين على تتبع المواد المقدمة للوظائف التي تتقدم إليها عبر المواقع الخارجية لأصحاب العمل...',
            ),
            isDark: isDark,
            onSurfaceColor: onSurfaceColor,
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({
    required this.title,
    required this.body,
    required this.isDark,
    required this.onSurfaceColor,
  });
  final String title;
  final String body;
  final bool isDark;
  final Color onSurfaceColor;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: widget.isDark ? const Color(0xFF0D2D4D) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: widget.onSurfaceColor.withOpacity(0.1)),
      ),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: widget.onSurfaceColor,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 12),
                Text(
                  widget.body,
                  style: TextStyle(
                    color: widget.onSurfaceColor.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
