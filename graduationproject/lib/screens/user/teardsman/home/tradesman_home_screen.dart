import 'package:flutter/material.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/state/recruitment_sync_store.dart';
import '../../home/tabs/recruitment_ui_utils.dart';
import 'tradesman_job_details_screen.dart';

class TradesmanHomeScreen extends StatelessWidget {
  final Function(int) onTabChange;
  const TradesmanHomeScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;
    final colorScheme = Theme.of(context).colorScheme;
    final tradesmanJobs = store.jobs.where((job) {
      return job.category.toLowerCase() == 'tradesman' ||
          job.category.toLowerCase() == 'service';
    }).toList();
    final List<String> companyLogos = [
      'assets/tradesman/الاهلي  (1).jpg',
      'assets/tradesman/حديد عز.jpg',
      'assets/tradesman/شاي العروسة.jpg',
      'assets/tradesman/شعار_سبايرو_سباتس.jpg',
      'assets/tradesman/طلبات.jpg',
      'assets/tradesman/فودافون.jpg',
      'assets/tradesman/Egyptair.png',
      'assets/tradesman/Egypt-post.png',
      'assets/tradesman/edita.png',
      'assets/tradesman/1obourland-1.png',
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 280,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/company/Onboarding/image 42 1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'اعرض خدمتك ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'لعملائك ',
                    style: TextStyle(color: Color(0xFF2563EB)),
                  ),
                  TextSpan(
                    text: 'بسهوله',
                    style: TextStyle(color: Color(0xFFFF7A2A)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نثق بهم و يثقون بنا',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: companyLogos.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => onTabChange(3),
                        borderRadius: BorderRadius.circular(12),
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
                                companyLogos[index],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.business,
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                
                // 1. Jobs Available Today
                _buildSectionHeader(
                  context, 
                  l10n.isAr ? "الوظائف المتاحة اليوم" : "Jobs Available Today", 
                  () => onTabChange(1), 
                  l10n.isAr
                ),
                const SizedBox(height: 16),
                if (tradesmanJobs.isEmpty)
                  _buildEmptyState(colorScheme, l10n)
                else
                  Column(
                    children: tradesmanJobs
                        .where((j) => j.acceptedCount < j.capacity)
                        .take(3)
                        .map((job) => _buildExceptionalJobCard(context, job, l10n))
                        .toList(),
                  ),

                const SizedBox(height: 32),
                _buildHowItWorks(context, l10n.isAr, Theme.of(context).brightness == Brightness.dark),
                const SizedBox(height: 32),

                // 2. Exceptional Jobs
                _buildSectionHeader(
                  context, 
                  l10n.isAr ? "فرص عمل استثنائية" : "Exceptional Jobs", 
                  () => onTabChange(1), 
                  l10n.isAr
                ),
                const SizedBox(height: 16),
                if (tradesmanJobs.where((j) => j.specialTag != null).isEmpty)
                  _buildEmptyState(colorScheme, l10n)
                else
                  Column(
                    children: tradesmanJobs
                        .where((j) => j.specialTag != null && j.acceptedCount < j.capacity)
                        .take(2)
                        .map((job) => _buildExceptionalJobCard(context, job, l10n))
                        .toList(),
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onTap, bool isAr) {
    return Row(
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
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          l10n.noJobsAvailable,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildExceptionalJobCard(
    BuildContext context,
    RecruitmentJob job,
    AppLocalizations l10n,
  ) {
    String title = l10n.translateJobTitle(job.title);
    final company = l10n.translateCompanyName(job.companyName);
    final location = l10n.translateLocation(job.location);
    
    // Filter unwanted words from title and badge
    final unwanted = ['خبرة', 'مطلوب', 'محترف', 'experience', 'required', 'professional'];
    for (final w in unwanted) {
      title = title.replaceAll(RegExp(w, caseSensitive: false), '').trim();
    }
    title = title.replaceAll(RegExp(r'\s+'), ' ');

    String badge = job.specialTag?.isNotEmpty == true ? job.specialTag! : (l10n.isAr ? 'مميز' : 'Featured');
    if (unwanted.any((w) => badge.toLowerCase().contains(w.toLowerCase()))) {
      badge = "";
    }

    final snippet = job.description.isNotEmpty
        ? job.description
        : (l10n.isAr 
            ? 'فرصة عمل مميزة في منطقتك مع إمكانية التواصل المباشر.' 
            : 'Great job opportunity in your area with direct communication.');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF213E75),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TradesmanJobDetailsScreen(job: job),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (badge.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7A2A).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Color(0xFFFF7A2A),
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '4.9',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    job.logoIcon ?? Icons.work_outline,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        company,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              snippet,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildMiniTag(context, Icons.location_on_outlined, location),
                _buildMiniTag(context, Icons.access_time, translateValue(job.type, l10n.isAr)),
                _buildMiniTag(
                  context, 
                  Icons.people_outline, 
                  l10n.isAr 
                    ? 'المقبولين: ${job.acceptedCount} / ${job.capacity}' 
                    : 'Accepted: ${job.acceptedCount} / ${job.capacity}'
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniTag(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconText(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorks(BuildContext context, bool isAr, bool isDark) {
    final titleColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white70 : Colors.black54;

    final steps = [
      {
        'title': isAr ? 'أنشئ حسابك المهني' : 'Create Professional Account',
        'desc': isAr ? 'سجل بياناتك، حدد مهنتك، واكتب خبراتك ليراك آلاف العملاء يومياً في منطقتك.' : 'Register your info, select your craft, and list your experience to be seen by thousands daily.',
        'icon': Icons.person_add_outlined,
        'color': const Color(0xFF4A90E2),
      },
      {
        'title': isAr ? 'اعرض مهاراتك' : 'Showcase Your Skills',
        'desc': isAr ? 'ارفع صوراً لأعمالك السابقة وحدد مناطق خدمتك وأسعارك التقديرية لجذب العملاء.' : 'Upload photos of your work, set service areas and estimated prices to attract clients.',
        'icon': Icons.auto_awesome_mosaic_outlined,
        'color': const Color(0xFFFFD700),
      },
      {
        'title': isAr ? 'تواصل مباشر' : 'Direct Connection',
        'desc': isAr ? 'استقبل اتصالات ورسائل مباشرة من العملاء المهتمين بخدماتك دون أي وسيط أو عمولة.' : 'Receive direct calls and messages from interested clients without any middleman.',
        'icon': Icons.chat_bubble_outline_rounded,
        'color': const Color(0xFFFF7A2A),
      },
      {
        'title': isAr ? 'ابنِ سمعتك وضاعف أرباحك' : 'Build Your Reputation',
        'desc': isAr ? 'احصل على تقييمات ممتازة من عملائك لتتصدر نتائج البحث وتضمن زيادة أرباحك وعملك باستمرار.' : 'Get excellent reviews to top search results and ensure continuous growth of your profits.',
        'icon': Icons.trending_up_rounded,
        'color': const Color(0xFF4CAF50),
      },
    ];

    return Column(
      children: [
        Center(
          child: Column(
            children: [
              Text(
                isAr ? 'كيف تنجز أعمالك مع جوبيتو؟' : 'How to get things done with Jobito?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: titleColor),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  isAr ? 'خطوات بسيطة لبناء ملف شخصي قوي وجذب مئات العملاء لخدماتك' : 'Simple steps to build a strong profile and attract hundreds of clients',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: subColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];
              return Container(
                width: 170,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.black12.withOpacity(0.05)),
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
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (step['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(step['icon'] as IconData, color: step['color'] as Color, size: 24),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      step['title'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: titleColor),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      step['desc'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: subColor, height: 1.4),
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
