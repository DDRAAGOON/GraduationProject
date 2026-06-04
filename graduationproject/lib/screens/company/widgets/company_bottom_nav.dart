// Bottom navigation for the recruiter main tabs.

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';

enum CompanyTab { home, chat, applicants, profile, analytics, ratings }

class CompanyBottomNav extends StatelessWidget {
  const CompanyBottomNav({super.key, required this.current});

  final CompanyTab current;

  int get _index => switch (current) {
    CompanyTab.home => 0,
    CompanyTab.chat => 1,
    CompanyTab.applicants => 2,
    CompanyTab.profile => 3,
    CompanyTab.analytics => 4,
    CompanyTab.ratings => 5,
  };

  void _go(BuildContext context, int index) {
    final route = switch (index) {
      0 => AppRoutes.companyDashboard,
      1 => AppRoutes.companyMessagesList,
      2 => AppRoutes.companyJobsHub,
      3 => AppRoutes.companyCompanyProfile,
      4 => AppRoutes.companyJobAnalytics,
      5 => AppRoutes.companyRatings,
      _ => AppRoutes.companyDashboard,
    };
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return NavigationBar(
      selectedIndex: _index,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      onDestinationSelected: (i) => _go(context, i),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          label: t.home,
        ),
        NavigationDestination(
          icon: const Icon(Icons.chat_bubble_outline),
          label: t.chat,
        ),
        NavigationDestination(
          icon: const Icon(Icons.groups_outlined),
          label: t.job,
        ),
        NavigationDestination(
          icon: const Icon(Icons.business_outlined),
          label: t.profile,
        ),
        NavigationDestination(
          icon: const Icon(Icons.bar_chart_outlined),
          label: t.stats,
        ),
        NavigationDestination(
          icon: const Icon(Icons.star_outline),
          label: t.tr(en: 'Ratings', ar: 'التقييمات'),
        ),
      ],
    );
  }
}
