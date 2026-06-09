// Shared app-bar icons (e.g. messages) for company shell screens.

import 'dart:io';

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/utils/image_helper.dart';

import '../../../shared/l10n/app_localizations.dart';

class CompanyProfileLeading extends StatelessWidget {
  const CompanyProfileLeading({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final profileImage = CompanyStore.instance.companyProfileImage;
    final imageProvider = getAppImageProvider(profileImage);

    return IconButton(
      tooltip: t.profile,
      onPressed: () =>
          Navigator.of(context).pushNamed(AppRoutes.companyProfileOverview),
      icon: ClipOval(
        child: imageProvider == null
            ? Container(
                width: 32,
                height: 32,
                color: Theme.of(context).colorScheme.surfaceBright,
                child: Icon(
                  Icons.business,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              )
            : Image(
                image: imageProvider,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 32,
                    height: 32,
                    color: Theme.of(context).colorScheme.surfaceBright,
                    child: Icon(
                      Icons.business,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  );
                },
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
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.companySettings),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}
