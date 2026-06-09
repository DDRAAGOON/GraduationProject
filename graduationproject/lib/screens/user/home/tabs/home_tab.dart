import 'package:flutter/material.dart';
import '../../../../shared/state/recruitment_sync_store.dart';
import '../../../../app/router/app_router.dart';
import 'recruitment_ui_utils.dart';

class HomeTab extends StatelessWidget {
  final Function(int) onTabChange;
  const HomeTab({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = RecruitmentSyncStore.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, String>> topCompanies = [
      {
        'en': 'Al Ahly SC',
        'ar': 'النادي الأهلي',
        'logo': 'assets/tradesman/الاهلي  (1).jpg',
      },
      {
        'en': 'Ezz Steel',
        'ar': 'حديد عز',
        'logo': 'assets/tradesman/حديد عز.jpg',
      },
      {
        'en': 'El Arrousa Tea',
        'ar': 'شاي العروسة',
        'logo': 'assets/tradesman/شاي العروسة.jpg',
      },
      {
        'en': 'Spiro Spathis',
        'ar': 'سبايرو سباتيس',
        'logo': 'assets/tradesman/شعار_سبايرو_سباتس.jpg',
      },
      {'en': 'Talabat', 'ar': 'طلبات', 'logo': 'assets/tradesman/طلبات.jpg'},
      {
        'en': 'Vodafone',
        'ar': 'فودافون',
        'logo': 'assets/tradesman/فودافون.jpg',
      },
      {
        'en': 'Egyptair',
        'ar': 'مصر للطيران',
        'logo': 'assets/tradesman/Egyptair.png',
      },
      {
        'en': 'Egypt Post',
        'ar': 'البريد المصري',
        'logo': 'assets/tradesman/Egypt-post.png',
      },
      {'en': 'Edita', 'ar': 'إيديتا', 'logo': 'assets/tradesman/edita.png'},
      {
        'en': 'Obour Land',
        'ar': 'عبور لاند',
        'logo': 'assets/tradesman/1obourland-1.png',
      },
    ];

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/tradesman/image 43.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: isAr
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                        children: [
                          TextSpan(
                            text: isAr ? 'جد وظيفة ' : 'Find your ',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: isAr ? 'أحلامك ' : 'dream job ',
                            style: const TextStyle(color: Color(0xFF0051DD)),
                          ),
                          TextSpan(
                            text: isAr ? 'اليوم' : 'today',
                            style: const TextStyle(color: Color(0xFFFF7A2A)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isAr
                          ? 'نربط المحترفين و الموهبين بافضل الفرص في مصر'
                          : 'Connecting professionals and talents with the best opportunities in Egypt',
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  isAr
                      ? 'نثق بهم ويثقون بنا'
                      : 'We trust them, and they trust us',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: topCompanies.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => onTabChange(3),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).dividerColor.withValues(alpha: 0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            topCompanies[index]['logo']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildHowItWorks(context, isAr, isDark),
              const SizedBox(height: 32),
              _buildSectionHeader(
                context,
                isAr ? "الوظائف المتاحة اليوم" : "Jobs Available Today",
                () => onTabChange(1),
                isAr,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: store.jobs
                      .where((j) => j.acceptedCount < j.capacity)
                      .take(2)
                      .map((j) => _buildCustomJobCard(context, j, isAr, isDark))
                      .toList(),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  isAr ? 'استكشف حسب الفئات' : 'Explore by Categories',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildCategoryTile(
                context,
                isAr ? "تقني" : "Technical",
                isAr ? "5 فرص" : "5 opportunities",
                Icons.memory,
                const Color(0xFFD9D9D9),
                isDark,
                isAr,
                () {
                  store.updateFilters(category: 'Technical');
                  onTabChange(1);
                },
              ),
              _buildCategoryTile(
                context,
                isAr ? "غير تقني" : "Non-Technical",
                isAr ? "3 فرص" : "3 opportunities",
                Icons.groups,
                const Color(0xFFD9D9D9),
                isDark,
                isAr,
                () {
                  store.updateFilters(category: 'Non-Technical');
                  onTabChange(1);
                },
              ),
              _buildCategoryTile(
                context,
                isAr ? "خدمات" : "Services",
                isAr ? "15 فرصة" : "15 opportunities",
                Icons.handyman,
                const Color(0xFFD9D9D9),
                isDark,
                isAr,
                () {
                  store.updateFilters(category: 'Service');
                  onTabChange(1);
                },
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(
                context,
                isAr ? "فرص عمل استثنائية" : "Exceptional Jobs",
                () => onTabChange(1),
                isAr,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: store.jobs
                      .where(
                        (j) =>
                            j.specialTag != null &&
                            j.acceptedCount < j.capacity,
                      )
                      .take(2)
                      .map(
                        (j) =>
                            _buildExceptionalJobCard(context, j, isAr, isDark),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onTap,
    bool isAr,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(isAr ? "عرض الكل" : "See All"),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomJobCard(
    BuildContext context,
    RecruitmentJob job,
    bool isAr,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).pushNamed(AppRoutes.userJobDetails, arguments: job),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF213E75),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildCompanyLogo(context, job.companyLogoUrl),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              job.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              job.companyName,
              style: const TextStyle(
                color: Color(0xFFFF7A2A),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              job.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            if (job.benefits.isNotEmpty) ...[
              Text(
                isAr
                    ? "مزايا إضافية: ${job.benefits.join(' • ')}"
                    : "Extra Benefits: ${job.benefits.join(' • ')}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                buildWhiteTag(translateValue(job.location, isAr)),
                buildWhiteTag(translateValue(job.type, isAr)),
                buildWhiteTag(isAr ? "1-3 سنوات" : "1-3 exp"),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                if (isAr) ...[
                  Text(
                    job.salaryRange,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  _buildJobitoApplyButton(context, job, isAr),
                ] else ...[
                  _buildJobitoApplyButton(context, job, isAr),
                  const Spacer(),
                  Text(
                    job.salaryRange,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExceptionalJobCard(
    BuildContext context,
    RecruitmentJob job,
    bool isAr,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).pushNamed(AppRoutes.userJobDetails, arguments: job),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF213E75),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildCompanyLogo(context, job.companyLogoUrl),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              job.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              job.companyName,
              style: const TextStyle(
                color: Color(0xFFFF7A2A),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            buildWhiteTag(translateValue(job.type, isAr)),
          ],
        ),
      ),
    );
  }

  Widget _buildJobitoApplyButton(
    BuildContext context,
    RecruitmentJob job,
    bool isAr,
  ) {
    return ElevatedButton(
      onPressed: () => Navigator.of(
        context,
      ).pushNamed(AppRoutes.userJobApplication, arguments: job),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0051DD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        isAr ? "قدم الآن" : "Apply Now",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryTile(
    BuildContext c,
    String t,
    String s,
    IconData i,
    Color col,
    bool isDark,
    bool isAr,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : col,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(isAr ? Icons.chevron_left : Icons.chevron_right),
            const Spacer(),
            Column(
              crossAxisAlignment: isAr
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  t,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  s,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(i, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorks(BuildContext context, bool isAr, bool isDark) {
    final titleColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white70 : Colors.black54;

    final steps = [
      {
        'title': isAr ? '1. ابحث عن تخصص' : '1. Search Speciality',
        'desc': isAr
            ? 'تصفح آلاف الحرفيين والشركات في مختلف التخصصات والمجالات.'
            : 'Browse thousands of tradesmen and companies in various specialties.',
        'icon': Icons.description_outlined,
        'color': const Color(0xFF4A90E2),
      },
      {
        'title': isAr ? '2. قارن واختر' : '2. Compare & Select',
        'desc': isAr
            ? 'شاهد التقييمات والأعمال السابقة واختر الأنسب لاحتياجاتك وميزانيتك.'
            : 'See reviews and previous work and choose the best fit for your needs.',
        'icon': Icons.compare_arrows_rounded,
        'color': const Color(0xFFFFD700),
      },
      {
        'title': isAr ? '3. تواصل فوراً' : '3. Connect Instantly',
        'desc': isAr
            ? 'تواصل مباشرة مع الحرفي أو الشركة عبر الهاتف أو الرسائل للاتفاق.'
            : 'Directly contact the tradesman or company via phone or messages.',
        'icon': Icons.chat_bubble_outline_rounded,
        'color': const Color(0xFFFF7A2A),
      },
      {
        'title': isAr ? '4. قيم تجربتك' : '4. Rate Your Experience',
        'desc': isAr
            ? 'شارك تقييمك بعد انتهاء العمل لمساعدة الآخرين في اختيار الأفضل.'
            : 'Share your review after completion to help others choose the best.',
        'icon': Icons.star_outline_rounded,
        'color': const Color(0xFF4CAF50),
      },
    ];

    return Column(
      children: [
        Center(
          child: Column(
            children: [
              Text(
                isAr
                    ? 'كيف تنجز أعمالك مع جوبيتو؟'
                    : 'How to get things done with Jobito?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  isAr
                      ? 'خطوات بسيطة للوصول إلى أفضل المحترفين والشركات لإنجاز أعمالك بأعلى جودة'
                      : 'Simple steps to reach the best professionals and companies',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: subColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? Colors.white10
                        : Colors.black12.withOpacity(0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (step['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        step['icon'] as IconData,
                        color: step['color'] as Color,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      step['title'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step['desc'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: subColor,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
