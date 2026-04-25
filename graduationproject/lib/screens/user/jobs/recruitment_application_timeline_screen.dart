import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';

import '../../../shared/state/recruitment_sync_store.dart';

class RecruitmentApplicationTimelineScreen extends StatelessWidget {
  const RecruitmentApplicationTimelineScreen({super.key, required this.application});

  final RecruitmentApplication application;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final steps = [
      'Applied',
      'In Review',
      'Shortlisted',
      'Final Review',
      'Hired',
    ];

    final stepsAr = [
      'تم التقديم',
      'قيد المراجعة',
      'القائمة المختصرة',
      'المراجعة النهائية',
      'تم التوظيف',
    ];

    final normalizedStatus = application.status;
    final currentIndex = steps.indexOf(normalizedStatus);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Image.asset(
          'assets/company/logo/logo.png',
          height: 150,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            isAr ? 'حالة الطلب' : 'Application Status',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            application.jobTitle,
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Column(
              children: List.generate(steps.length, (index) {
                final active = index <= (currentIndex < 0 ? 0 : currentIndex);
                final isLast = index == steps.length - 1;

                return Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Icon(
                              active ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: active ? const Color(0xFF49769F) : Colors.grey.shade300,
                              size: 28,
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 40,
                                color: active && index < currentIndex
                                    ? const Color(0xFF49769F)
                                    : Colors.grey.shade200,
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAr ? stepsAr[index] : steps[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                                  color: active ? Colors.black87 : Colors.black38,
                                ),
                              ),
                              if (index == currentIndex)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    isAr 
                                      ? 'حالتك الحالية لـ ${application.jobTitle}'
                                      : 'Current status for ${application.jobTitle}',
                                    style: const TextStyle(color: Color(0xFF49769F), fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
