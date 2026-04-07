import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../../../constants/app_images.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: IconButton(
                icon: const Icon(Icons.tune, color: Colors.black, size: 20),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              "You have 2 Notifications today.",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 32),
            
            // Today Section
            const Text(
              "Today",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildNotificationItem(
              name: "Joe Bartmann",
              action: "Send you a message",
              time: "2h ago",
              image: AppImages.companyProfile2,
              isUnread: true,
            ),
            const Divider(color: Colors.white12, height: 48),
            _buildNotificationItem(
              name: "Ally Wales",
              action: "Send you a message",
              time: "9h ago",
              image: AppImages.companyProfile3,
              isUnread: true,
            ),
            const Divider(color: Colors.white12, height: 48),

            // This Week Section
            const Text(
              "This Week",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildNotificationItem(
              name: "Ruben Culhane",
              action: "Liked your posted",
              time: "2D ago",
              image: AppImages.companyProfile6,
              isUnread: true,
            ),
            const Divider(color: Colors.white12, height: 48),
            _buildNotificationItem(
              name: "Warren Buffet",
              action: "Liked your posted",
              time: "6D ago",
              initials: "WA",
              isUnread: true,
            ),
            const Divider(color: Colors.white12, height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String name,
    required String action,
    required String time,
    String? image,
    String? initials,
    bool isUnread = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isUnread)
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.black,
          backgroundImage: image != null ? AssetImage(image) : null,
          child: initials != null 
            ? Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)) 
            : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                  children: [
                    TextSpan(text: name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: " "),
                    TextSpan(text: action, style: const TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(color: Colors.white24, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
