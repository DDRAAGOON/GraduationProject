// Charts and stats for a single job posting — mobile-first redesign.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/models/job.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../widgets/company_app_bar_actions.dart';
import '../widgets/company_bottom_nav.dart';
import '../widgets/glowing_chatbot_fab.dart';
import '../../user/messages/chat_thread_screen.dart';
import '../../../constants/app_images.dart';

class CompanyJobAnalyticsScreen extends StatelessWidget {
  const CompanyJobAnalyticsScreen({super.key, required this.job});
  final Job job;
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: t.stats,
      showBack: false,
      leading: const CompanyProfileLeading(),
      actions: const [CompanyAppBarActions()],
      body: _AnalyticsBody(job: job),
      bottomNavigationBar: const CompanyBottomNav(
        current: CompanyTab.analytics,
      ),
      floatingActionButton: GlowingChatbotFAB(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatThreadScreen(
              name: t.isAr ? 'مساعد جوبيتو الذكي' : 'Jobito AI Assistant',
              image: AppImages.jobito,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnalyticsBody extends StatefulWidget {
  const _AnalyticsBody({required this.job});
  final Job job;
  @override
  State<_AnalyticsBody> createState() => _AnalyticsBodyState();
}

class _AnalyticsBodyState extends State<_AnalyticsBody> {
  int _selectedPeriod = 0; // 0: Day, 1: Month, 2: Year
  int _selectedTab = 0; // 0: Overview, 1: Job Views, 2: Applications
  bool _isLoading = true;
  String? _errorMessage;
  // ─── متغيرات لحفظ بيانات الـ API ─────────────────────────────────
  int _totalApplicants = 0;
  int _totalViews = 0;
  int _reviewingCount = 0;
  int _acceptedCount = 0;
  int _rejectedCount = 0;
  final Map<int, List<double>> _viewsData = {
    0: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    1: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    2: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
  };
  final Map<int, List<double>> _appsData = {
    0: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    1: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    2: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
  };
  // X-axis labels per period
  static const _labelsEn = {
    0: ['9am', '10am', '11am', '12pm', '1pm', '2pm', '3pm'],
    1: ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7'],
    2: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
  };
  static const _labelsAr = {
    0: ['9ص', '10ص', '11ص', '12م', '1م', '2م', '3م'],
    1: ['أ1', 'أ2', 'أ3', 'أ4', 'أ5', 'أ6', 'أ7'],
    2: ['ينا', 'فبر', 'مار', 'أبر', 'ماي', 'يون', 'يول'],
  };
  @override
  void initState() {
    super.initState();
    _fetchAnalyticsFromApi();
  }

  // ─── دالة جلب البيانات من الـ API ───────────────────────────────
  Future<void> _fetchAnalyticsFromApi() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // ⚠️ تأكد من تغيير الرابط ليتوافق مع الـ Backend الخاص بك
      final url = Uri.parse(
        'https://your-api.com/api/jobs/${widget.job.id}/analytics',
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer YOUR_TOKEN', // أضف التوكن إذا كان مطلوباً
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // ⚠️ قم بتغيير المفاتيح (keys) هنا لتتطابق مع الرد القادم من الـ Backend
          _totalApplicants = data['totalApplicants'] ?? 0;
          _totalViews = data['totalViews'] ?? 0;

          _reviewingCount = data['statusBreakdown']?['reviewing'] ?? 0;
          _acceptedCount = data['statusBreakdown']?['accepted'] ?? 0;
          _rejectedCount = data['statusBreakdown']?['rejected'] ?? 0;
          // إذا كانت بيانات الرسم البياني تأتي من الـ API قم بفكها هكذا:
          // _viewsData[0] = List<double>.from(data['charts']['day']['views'].map((x) => x.toDouble()));
          // _appsData[0] = List<double>.from(data['charts']['day']['apps'].map((x) => x.toDouble()));
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'حدث خطأ في السيرفر: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ في الاتصال: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: cs.error, size: 48),
            const SizedBox(height: 16),
            Text(_errorMessage!, style: TextStyle(color: cs.error)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchAnalyticsFromApi,
              child: Text(isAr ? 'إعادة المحاولة' : 'Retry'),
            ),
          ],
        ),
      );
    }
    final job = widget.job;
    final views = List<double>.from(_viewsData[_selectedPeriod]!);
    final apps = List<double>.from(_appsData[_selectedPeriod]!);
    final periods = isAr ? ['يوم', 'شهر', 'سنة'] : ['Day', 'Month', 'Year'];
    final tabs = isAr
        ? ['نظرة عامة', 'مشاهدات', 'طلبات']
        : ['Overview', 'Views', 'Applications'];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        // ── KPI chips row ─────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _KpiChip(
                label: isAr ? 'حالة الوظيفة' : 'Job Status',
                value: isAr
                    ? (job.status == 'Open' ? 'مفتوحة' : 'مغلقة')
                    : job.status,
                icon: Icons.work_outline_rounded,
                color: job.status == 'Open'
                    ? const Color(0xFF4A80D8)
                    : Colors.grey,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _KpiChip(
                label: isAr ? 'إجمالي المتقدمين' : 'Total Applicants',
                value: '$_totalApplicants',
                icon: Icons.people_outline_rounded,
                color: const Color(0xFF34D399),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // ── Main chart card ────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'إحصائيات الوظيفة' : 'Job Statistics',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    // Period toggle
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(periods.length, (i) {
                          final sel = _selectedPeriod == i;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedPeriod = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: sel
                                    ? const Color(0xFF4A80D8)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                periods[i],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: sel
                                      ? Colors.white
                                      : cs.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  isAr
                      ? 'عرض نظرة عامة لـ ${_selectedPeriod == 0
                            ? 'اليوم'
                            : _selectedPeriod == 1
                            ? 'الشهر'
                            : 'السنة'}'
                      : 'Overview for this ${_selectedPeriod == 0
                            ? 'day'
                            : _selectedPeriod == 1
                            ? 'month'
                            : 'year'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(tabs.length, (i) {
                    final sel = _selectedTab == i;
                    return Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = i),
                        child: Column(
                          children: [
                            Text(
                              tabs[i],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: sel
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: sel
                                    ? const Color(0xFF4A80D8)
                                    : cs.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 6),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 3,
                              width: sel ? 32 : 0,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A80D8),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Divider(
                height: 1,
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 20),
              // Inline mini-stats
              if (_selectedTab == 0 || _selectedTab == 1) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _InlineStat(
                    label: isAr ? 'مشاهدات الوظيفة' : 'Job Views',
                    value: '$_totalViews',
                    delta: '+12%', // يفضل جلبها من الـ API
                    color: Colors.orange,
                    icon: Icons.visibility_outlined,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (_selectedTab == 0 || _selectedTab == 2) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _InlineStat(
                    label: isAr ? 'طلبات التقديم' : 'Applications',
                    value: '$_totalApplicants',
                    delta: '+5%', // يفضل جلبها من الـ API
                    color: const Color(0xFF4A80D8),
                    icon: Icons.assignment_outlined,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              // Bar Chart
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 20, bottom: 8),
                child: SizedBox(
                  height: 200,
                  child: _AnalyticsBarChart(
                    views: views,
                    apps: apps,
                    isAr: isAr,
                    xLabels: isAr
                        ? _labelsAr[_selectedPeriod]!
                        : _labelsEn[_selectedPeriod]!,
                    maxY:
                        (_viewsData[_selectedPeriod]!.reduce(
                                  (a, b) => a > b ? a : b,
                                ) +
                                _appsData[_selectedPeriod]!.reduce(
                                  (a, b) => a > b ? a : b,
                                ))
                            .clamp(4.0, double.infinity) +
                        2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Legend
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    _LegendDot(
                      color: Colors.orange,
                      label: isAr ? 'مشاهدات الوظيفة' : 'Job Views',
                    ),
                    const SizedBox(width: 20),
                    _LegendDot(
                      color: const Color(0xFF4A80D8),
                      label: isAr ? 'طلبات التقديم' : 'Applications',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // ── Applicants Breakdown card ──────────────────────────────
        _ApplicantsBreakdownCard(
          isAr: isAr,
          isDark: isDark,
          cs: cs,
          total: _totalApplicants,
          reviewing: _reviewingCount,
          accepted: _acceptedCount,
          rejected: _rejectedCount,
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Small Widgets
// ──────────────────────────────────────────────────────────────────────────────
class _KpiChip extends StatelessWidget {
  const _KpiChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _InlineStat extends StatelessWidget {
  const _InlineStat({
    required this.label,
    required this.value,
    required this.delta,
    required this.color,
    required this.icon,
  });
  final String label;
  final String value;
  final String delta;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: color,
                    height: 1.1,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              delta,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.65),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Bar Chart Widget
// ──────────────────────────────────────────────────────────────────────────────
class _AnalyticsBarChart extends StatelessWidget {
  const _AnalyticsBarChart({
    required this.views,
    required this.apps,
    required this.isAr,
    required this.maxY,
    required this.xLabels,
  });
  final List<double> views;
  final List<double> apps;
  final bool isAr;
  final double maxY;
  final List<String> xLabels;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => cs.surfaceContainerHigh,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final label = rodIndex == 0
                  ? (isAr ? 'طلبات: ' : 'Apps: ')
                  : (isAr ? 'مشاهدات: ' : 'Views: ');
              return BarTooltipItem(
                '$label${rod.toY.toStringAsFixed(0)}',
                TextStyle(
                  color: rod.color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, _) {
                final idx = value.toInt();
                if (idx < 0 || idx >= xLabels.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    xLabels[idx],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, _) {
                if (value % 1 != 0) return const SizedBox.shrink();
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: cs.onSurface.withValues(alpha: 0.45),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 6 ? (maxY / 4).ceilToDouble() : 1,
          getDrawingHorizontalLine: (_) => FlLine(
            color: cs.outlineVariant.withValues(alpha: 0.3),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(7, (i) {
          return BarChartGroupData(
            x: i,
            groupVertically: false,
            barsSpace: 4,
            barRods: [
              BarChartRodData(
                toY: apps[i],
                color: const Color(0xFF4A80D8),
                width: 10,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              BarChartRodData(
                toY: views[i],
                color: Colors.orange.shade400,
                width: 10,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Applicants Breakdown Card
// ──────────────────────────────────────────────────────────────────────────────
class _ApplicantsBreakdownCard extends StatelessWidget {
  const _ApplicantsBreakdownCard({
    required this.isAr,
    required this.isDark,
    required this.cs,
    required this.total,
    required this.reviewing,
    required this.accepted,
    required this.rejected,
  });
  final bool isAr;
  final bool isDark;
  final ColorScheme cs;

  final int total;
  final int reviewing;
  final int accepted;
  final int rejected;
  @override
  Widget build(BuildContext context) {
    final types = [
      ('Reviewing', const Color(0xFFFBBF24), reviewing),
      ('Accepted', const Color(0xFF34D399), accepted),
      ('Rejected', const Color(0xFFEF4444), rejected),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerLow : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isAr ? 'حالات المتقدمين للوظيفة' : 'Applicants Status Summary',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          // Big number + stacked bar
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$total',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF4A80D8),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  isAr
                      ? (total == 1 ? 'متقدم' : 'متقدمين')
                      : (total == 1 ? 'Applicant' : 'Applicants'),
                  style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Segmented progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                children: types.map((t) {
                  final frac = total == 0 ? 0.0 : t.$3 / total;
                  return Flexible(
                    flex: (frac * 1000).toInt().clamp(0, 1000),
                    child: Container(color: t.$2),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Status rows
          Column(
            children: types.map((t) {
              final arLabels = {
                'Reviewing': 'قيد المراجعة',
                'Accepted': 'مقبول',
                'Rejected': 'مرفوض',
              };
              final label = isAr ? arLabels[t.$1]! : t.$1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: t.$2,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: cs.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                    Text(
                      '${t.$3}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
