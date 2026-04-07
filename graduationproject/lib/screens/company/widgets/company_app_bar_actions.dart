// Shared app-bar icons (e.g. messages) for company shell screens.

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../constants/app_images.dart';

import '../../../shared/l10n/app_localizations.dart';

class CompanyProfileLeading extends StatelessWidget {
  const CompanyProfileLeading({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return IconButton(
      tooltip: t.profile,
      onPressed: () =>
          Navigator.of(context).pushNamed(AppRoutes.companyProfileOverview),
      icon: ClipOval(
        child: Image.asset(
          AppImages.companyProfileImage,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CompanyAppBarActions extends StatelessWidget {
  const CompanyAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: t.tr(en: 'Post a job', ar: 'إضافة وظيفة'),
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.companyPostJobStep1),
          icon: const Icon(Icons.add_circle_outline),
        ),
        IconButton(
          tooltip: t.tr(en: 'Notifications', ar: 'الإشعارات'),
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.companyNotifications),
          icon: const Icon(Icons.notifications_none),
        ),
        IconButton(
          tooltip: t.settings,
          onPressed: () => Navigator.of(
            context,
          ).pushNamed(AppRoutes.companySettings),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}
