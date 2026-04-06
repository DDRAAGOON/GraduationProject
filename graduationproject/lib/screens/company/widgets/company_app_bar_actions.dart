import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../constants/app_images.dart';

class CompanyProfileLeading extends StatelessWidget {
  const CompanyProfileLeading({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Company profile',
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Post a job',
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.companyPostJobStep1),
          icon: const Icon(Icons.add_circle_outline),
        ),
        IconButton(
          tooltip: 'Notifications',
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.companyNotifications),
          icon: const Icon(Icons.notifications_none),
        ),
        IconButton(
          tooltip: 'Settings',
          onPressed: () => Navigator.of(
            context,
          ).pushNamed(AppRoutes.companyNotificationSetting),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}
