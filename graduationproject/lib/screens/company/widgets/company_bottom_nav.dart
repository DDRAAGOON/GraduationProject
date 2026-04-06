import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';

enum CompanyTab { home, chat, applicants, companyProfile, analytics }

class CompanyBottomNav extends StatelessWidget {
  const CompanyBottomNav({super.key, required this.current});

  final CompanyTab current;

  int get _index => switch (current) {
    CompanyTab.home => 0,
    CompanyTab.chat => 1,
    CompanyTab.applicants => 2,
    CompanyTab.companyProfile => 3,
    CompanyTab.analytics => 4,
  };

  void _go(BuildContext context, int index) {
    final route = switch (index) {
      0 => AppRoutes.companyDashboard,
      1 => AppRoutes.companyMessagesList,
      2 => AppRoutes.companyJobsHub,
      3 => AppRoutes.companyCompanyProfile,
      4 => AppRoutes.companyJobAnalytics,
      _ => AppRoutes.companyDashboard,
    };
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _index,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      onDestinationSelected: (i) => _go(context, i),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
        NavigationDestination(icon: Icon(Icons.groups_outlined), label: 'Job'),
        NavigationDestination(
          icon: Icon(Icons.business_outlined),
          label: 'Company Profile',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          label: 'Stats',
        ),
      ],
    );
  }
}
