import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../../../constants/app_images.dart';
import 'chat_thread_screen.dart';

class MessagesListScreen extends StatelessWidget {
  const MessagesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Top Bar: Logo, Company Name, Plus, Notification
              _buildTopBar(),
              const SizedBox(height: 25),
              const Text(
                "Messages",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              // Search Bar
              _buildSearchBar(),
              const SizedBox(height: 20),
              // Messages List
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
                    const Divider(color: Colors.white12, height: 1),
                    _buildMessageItem(
                      context,
                      name: "Ally Wales",
                      message: "Hey thanks for your interview...",
                      time: "3:40 PM",
                      image: AppImages.companyProfile3,
                    ),
                    const Divider(color: Colors.white12, height: 1),
                    _buildMessageItem(
                      context,
                      name: "James Gardner",
                      message: "Hey thanks for your interview...",
                      time: "3:40 PM",
                      image: AppImages.companyProfile4,
                    ),
                    const Divider(color: Colors.white12, height: 1),
                    _buildMessageItem(
                      context,
                      name: "Allison Geidt",
                      message: "Hey thanks for your interview...",
                      time: "3:40 PM",
                      image: AppImages.companyProfile5,
                    ),
                    const Divider(color: Colors.white12, height: 1),
                    _buildMessageItem(
                      context,
                      name: "Ruben Culhane",
                      message: "Hey thanks for your interview...",
                      time: "3:40 PM",
                      image: AppImages.companyProfile6,
                    ),
                    const Divider(color: Colors.white12, height: 1),
                    _buildMessageItem(
                      context,
                      name: "Lydia Diaz",
                      message: "Hey thanks for your interview...",
                      time: "3:40 PM",
                      image: AppImages.companyProfile7,
                    ),
                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Nomad",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D2D4D),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 10),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white12),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.white54),
          hintText: "Search messages",
          hintStyle: TextStyle(color: Colors.white38),
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
          color: isHighlighted ? Colors.white : Colors.transparent,
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
                          color: isHighlighted ? Colors.black : Colors.white,
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
                          color: isHighlighted ? Colors.black45 : Colors.white38,
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
                      color: isHighlighted ? Colors.black54 : Colors.white60,
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
