import 'package:flutter/material.dart';
import '../../../constants/app_images.dart';
import '../../../shared/l10n/app_localizations.dart';
import 'chat_thread_screen.dart';

class MessagesListScreen extends StatelessWidget {
  const MessagesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildTopBar(context),
              const SizedBox(height: 25),
              Text(
                t.messages,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildSearchBar(context, t),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildMessageItem(
                      context,
                      name: "Joe Bartmann",
                      message: "Hey thanks for your interview...",
                      time: "3:40 PM",
                      image: AppImages.companyProfile2,
                    ),
                    Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 1),
                    _buildMessageItem(
                      context,
                      name: "Ally Wales",
                      message: "Hey thanks for your interview...",
                      time: "3:40 PM",
                      image: AppImages.companyProfile3,
                    ),
                    Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 1),
                    _buildMessageItem(
                      context,
                      name: "James Gardner",
                      message: "Hey thanks for your interview...",
                      time: "3:40 PM",
                      image: AppImages.companyProfile4,
                    ),
                    Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 1),
                    _buildMessageItem(
                      context,
                      name: "Allison Geidt",
                      message: "Hey thanks for your interview...",
                      time: "3:40 PM",
                      image: AppImages.companyProfile5,
                    ),
                    Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 1),
                    _buildMessageItem(
                      context,
                      name: "Ruben Culhane",
                      message: "Hey thanks for your interview...",
                      time: "3:40 PM",
                      image: AppImages.companyProfile6,
                    ),
                    Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 1),
                    _buildMessageItem(
                      context,
                      name: "Lydia Diaz",
                      message: "Hey thanks for your interview...",
                      time: "3:40 PM",
                      image: AppImages.companyProfile7,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nomad",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF0D2D4D)
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 10),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.onSurface),
                onPressed: () {},
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
      ),
      child: TextField(
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
          hintText: t.tr(en: "Search messages", ar: "البحث في الرسائل"),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildMessageItem(
    BuildContext context, {
    required String name,
    required String message,
    required String time,
    required String image,
    bool isOnline = false,
    bool isHighlighted = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatThreadScreen(
              name: name,
              image: image,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHighlighted
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
          borderRadius: isHighlighted
            ? const BorderRadius.only(
                topLeft: Radius.circular(50),
                bottomLeft: Radius.circular(50),
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(20),
              )
            : BorderRadius.zero,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage(image),
              backgroundColor: Colors.white12,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isOnline) ...[
                        const SizedBox(width: 5),
                        const Icon(Icons.circle, color: Colors.blue, size: 8),
                      ],
                      const Spacer(),
                      Text(
                        time,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
