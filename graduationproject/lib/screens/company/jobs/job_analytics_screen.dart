// Charts and stats for a single job posting.

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/models/job.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_title.dart';
import '../widgets/company_app_bar_actions.dart';
import '../widgets/company_bottom_nav.dart';

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            job.title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 640) {
                return Column(
                  children: [
                    _BigMetric(
                      title: t.tr(en: 'Total Views', ar: 'إجمالي المشاهدات'),
                      value: t.tr(en: '23,564', ar: '٢٣,٥٦٤'),
                      delta: t.tr(en: '+6.4%', ar: '٦.٤%+'),
                    ),
                    const SizedBox(height: 12),
                    _BigMetric(
                      title: t.tr(en: 'Total Applied', ar: 'إجمالي المتقدمين'),
                      value: t.tr(en: '132', ar: '١٣٢'),
                      delta: t.tr(en: '-0.4%', ar: '٠.٤%-'),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: _BigMetric(
                      title: t.tr(en: 'Total Views', ar: 'إجمالي المشاهدات'),
                      value: t.tr(en: '23,564', ar: '٢٣,٥٦٤'),
                      delta: t.tr(en: '+6.4%', ar: '٦.٤%+'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _BigMetric(
                      title: t.tr(en: 'Total Applied', ar: 'إجمالي المتقدمين'),
                      value: t.tr(en: '132', ar: '١٣٢'),
                      delta: t.tr(en: '-0.4%', ar: '٠.٤%-'),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          SectionTitle(t.tr(en: 'Job listing view stats', ar: 'إحصائيات مشاهدات إعلان الوظيفة')),
          const SizedBox(height: 10),
          const RepaintBoundary(child: _ApplicationsLineChart()),
          const SizedBox(height: 18),
          SectionTitle(t.tr(en: 'Traffic channel', ar: 'قنوات الزيارات')),
          const SizedBox(height: 10),
          const RepaintBoundary(child: _TrafficDonutChart()),
          const SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: const CompanyBottomNav(
        current: CompanyTab.analytics,
      ),
    );
  }
}

class _BigMetric extends StatelessWidget {
  const _BigMetric({
    required this.title,
    required this.value,
    required this.delta,
  });

  final String title;
  final String value;
  final String delta;

  @override
  Widget build(BuildContext context) {
    final positive = delta.contains('+');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    delta,
                    style: TextStyle(
                      color: positive ? Colors.tealAccent : Colors.redAccent,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicationsLineChart extends StatelessWidget {
  const _ApplicationsLineChart();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    const points = <FlSpot>[
      FlSpot(0, 18),
      FlSpot(1, 22),
      FlSpot(2, 19),
      FlSpot(3, 27),
      FlSpot(4, 31),
      FlSpot(5, 29),
      FlSpot(6, 36),
    ];
    final chartColor = Theme.of(context).colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.tr(en: 'Applications (last 7 days)', ar: 'الطلبات (لآخر ٧ أيام)'),
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 230,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 10,
                  maxY: 40,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Colors.black.withOpacity(0.06),
                      strokeWidth: 1,
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Colors.white,
                      tooltipBorder: BorderSide(
                        color: Colors.black.withOpacity(0.08),
                      ),
                      getTooltipItems: (spots) => spots
                          .map(
                            (spot) => LineTooltipItem(
                              '${_dayLabel(spot.x.toInt(), t.isAr)}\n${spot.y.toStringAsFixed(0)} ${t.tr(en: 'applicants', ar: 'متقدم')}',
                              const TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 34,
                        interval: 10,
                        getTitlesWidget: (value, _) => Text(
                          t.tr(en: value.toInt().toString(), ar: value.toInt().toString().replaceAll('0', '٠').replaceAll('1', '١').replaceAll('2', '٢').replaceAll('3', '٣').replaceAll('4', '٤').replaceAll('5', '٥').replaceAll('6', '٦').replaceAll('7', '٧').replaceAll('8', '٨').replaceAll('9', '٩')),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, _) => Text(
                          _dayLabel(value.toInt(), t.isAr),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: points,
                      isCurved: true,
                      color: chartColor,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) =>
                            FlDotCirclePainter(
                              radius: 3.2,
                              color: chartColor,
                              strokeWidth: 1.4,
                              strokeColor: Colors.white,
                            ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: chartColor.withOpacity(0.12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrafficDonutChart extends StatelessWidget {
  const _TrafficDonutChart();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final channels = <_ChannelSection>[
      _ChannelSection(t.tr(en: 'Direct', ar: 'مباشر'), 48, const Color(0xFF2F6FDB)),
      _ChannelSection(t.tr(en: 'Social', ar: 'تواصل إجتماعي'), 23, const Color(0xFF22C55E)),
      _ChannelSection(t.tr(en: 'Organic', ar: 'عضوي (بحث)'), 24, const Color(0xFFF59E0B)),
      _ChannelSection(t.tr(en: 'Other', ar: 'أخرى'), 5, const Color(0xFF6B7280)),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 42,
                  sections: channels
                      .map(
                        (channel) => PieChartSectionData(
                          color: channel.color,
                          value: channel.value.toDouble(),
                          title: t.tr(en: '${channel.value}%', ar: '٪${channel.value.toString().replaceAll('0', '٠').replaceAll('1', '١').replaceAll('2', '٢').replaceAll('3', '٣').replaceAll('4', '٤').replaceAll('5', '٥').replaceAll('6', '٦').replaceAll('7', '٧').replaceAll('8', '٨').replaceAll('9', '٩')}'),
                          radius: 56,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: channels
                  .map(
                    (channel) => _LegendDot(
                      label: t.tr(en: '${channel.label} ${channel.value}%', ar: '${channel.label} ٪${channel.value.toString().replaceAll('0', '٠').replaceAll('1', '١').replaceAll('2', '٢').replaceAll('3', '٣').replaceAll('4', '٤').replaceAll('5', '٥').replaceAll('6', '٦').replaceAll('7', '٧').replaceAll('8', '٨').replaceAll('9', '٩')}'),
                      color: channel.color,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChannelSection {
  const _ChannelSection(this.label, this.value, this.color);
  final String label;
  final int value;
  final Color color;
}

String _dayLabel(int value, bool isAr) {
  switch (value) {
    case 0:
      return isAr ? 'الإثنين' : 'Mon';
    case 1:
      return isAr ? 'الثلاثاء' : 'Tue';
    case 2:
      return isAr ? 'الأربعاء' : 'Wed';
    case 3:
      return isAr ? 'الخميس' : 'Thu';
    case 4:
      return isAr ? 'الجمعة' : 'Fri';
    case 5:
      return isAr ? 'السبت' : 'Sat';
    case 6:
      return isAr ? 'الأحد' : 'Sun';
    default:
      return '';
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
