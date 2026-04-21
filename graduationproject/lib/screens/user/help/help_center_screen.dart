import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sort By Row
              Row(
                children: [
                  Text(t.tr(en: "Sort by: ", ar: "صنف حسب: "), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 14)),
                  Text(t.tr(en: "Most relevant", ar: "الأكثر صلة"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.bold)),
                  Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), size: 20),
                ],
              ),
              const SizedBox(height: 30),

              // Sections
              _buildHelpSection(
                context, t,
                title: t.tr(en: "What is My Applications?", ar: "ما هي طلباتي؟"),
                content: t.tr(en: "My Applications is a way for you to track jobs as you move through the application process.", ar: "طلباتي هي وسيلة لك لتتبع الوظائف أثناء تحركك خلال عملية التقديم."),
              ),
              Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

              _buildHelpSection(
                context, t,
                title: t.tr(en: "How to access my applications history", ar: "كيفية الوصول إلى سجل طلباتي"),
                content: t.tr(en: "To access applications history, go to your My Applications page on your dashboard profile.", ar: "للوصول إلى سجل الطلبات، انتقل إلى صفحة طلباتي في ملفك الشخصي."),
              ),
              Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

              _buildHelpSection(
                context, t,
                title: t.tr(en: "Not seeing jobs you applied in your my application list?", ar: "ألا ترى الوظائف التي تقدمت إليها في قائمة طلباتي؟"),
                content: t.tr(en: "Please note that we are unable to track materials submitted for jobs you apply to via an employer's site.", ar: "يرجى ملاحظة أننا غير قادرين على تتبع المواد المقدمة للوظائف التي تتقدم إليها عبر موقع صاحب العمل."),
              ),
              Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

              const SizedBox(height: 20),

              // Contact Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            t.tr(en: "Didn't find what you were looking for?", ar: "لم تجد ما كنت تبحث عنه؟"),
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          t.tr(en: "Contact our customer service", ar: "اتصل بخدمة العملاء لدينا"),
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text(t.tr(en: "Contact Us", ar: "اتصل بنا"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chat_bubble, color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context, AppLocalizations t, {required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.more_horiz, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Text(t.tr(en: "Was this article helpful?", ar: "هل كان هذا المقال مفيدًا؟"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 12)),
            const Spacer(),
            _buildVoteButton(context, t.tr(en: "Yes", ar: "نعم"), Icons.thumb_up_outlined),
            const SizedBox(width: 10),
            _buildVoteButton(context, t.tr(en: "No", ar: "لا"), Icons.thumb_down_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildVoteButton(BuildContext context, String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 14),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12)),
        ],
      ),
    );
  }
}
