import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sort By Row
              Row(
                children: const [
                  Text("Sort by: ", style: TextStyle(color: Colors.white54, fontSize: 14)),
                  Text("Most relevant", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 20),
                ],
              ),
              const SizedBox(height: 30),

              // Sections
              _buildHelpSection(
                title: "What is My Applications?",
                content: "My Applications is a way for you to track jobs as you move through the application process. Depending on the job you applied to, you may also receive notifications indicating that an application has been actioned by an employer.",
              ),
              const Divider(color: Colors.white12, height: 40),

              _buildHelpSection(
                title: "How to access my applications history",
                content: "To access applications history, go to your My Applications page on your dashboard profile. You must be signed in to your Jobito account to view this page.",
              ),
              const Divider(color: Colors.white12, height: 40),

              _buildHelpSection(
                title: "Not seeing jobs you applied in your my application list?",
                content: "Please note that we are unable to track materials submitted for jobs you apply to via an employer's site. As a result, these applications are not recorded in the My Applications section of your Jobito account. We suggest keeping a personal record of all positions you have applied to externally.",
              ),
              const Divider(color: Colors.white12, height: 40),

              const SizedBox(height: 20),

              // Contact Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF5A87B6), // Light blue from image
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 200,
                          child: Text(
                            "Didn't find what you were looking for?",
                            style: TextStyle(color: Color(0xFF001E3A), fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Contact our customer service",
                          style: TextStyle(color: Color(0xFF001E3A), fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF001E3A),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text("Contact Us", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF001E3A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chat_bubble, color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(Icons.more_horiz, color: Colors.white54),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Text("Was this article helpful?", style: TextStyle(color: Colors.white54, fontSize: 12)),
            const Spacer(),
            _buildVoteButton("Yes", Icons.thumb_up_outlined),
            const SizedBox(width: 10),
            _buildVoteButton("No", Icons.thumb_down_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildVoteButton(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
