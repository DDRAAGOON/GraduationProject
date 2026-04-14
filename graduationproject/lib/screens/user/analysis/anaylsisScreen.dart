import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildTopIconButton(Icons.add),
                  const SizedBox(width: 12),
                  _buildTopIconButton(Icons.notifications_none, hasBadge: true),
                  const SizedBox(width: 12),
                  _buildTopIconButton(Icons.settings_outlined),
                ],
              ),
              const SizedBox(height: 30),

              // Total Jobs Applied Card
              _buildStatCard(
                title: "Total Jobs Applied",
                value: "45",
                icon: Icons.description_outlined,
              ),
              const SizedBox(height: 16),

              // Interviewed Card
              _buildStatCard(
                title: "Viewed",
                value: "18",
                icon: Icons.question_answer_outlined,
              ),
              const SizedBox(height: 16),

              // Jobs Applied Status Card
              _buildChartCard(),
              const SizedBox(height: 100), // Space for bottom nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopIconButton(IconData icon, {bool hasBadge = false}) {
    return Stack(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF0D2D4D),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        if (hasBadge)
          Positioned(
            right: 12,
            top: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(2), // Sharp corners as in image
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Icon(
            icon,
            color: Colors.white24,
            size: 80,
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        children: [
          const Text(
            "Jobs Applied Status",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: CircularProgressIndicator(
                  value: 0.6,
                  strokeWidth: 28,
                  backgroundColor: const Color(0xFF094174).withOpacity(0.5),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF094174)),
                ),
              ),
              SizedBox(
                height: 180,
                width: 180,
                child: CircularProgressIndicator(
                  value: 0.4,
                  strokeWidth: 28,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey.withOpacity(0.3)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _buildLegendItem(color: Colors.white, text: "60%", subtext: "Unsuitable"),
          const SizedBox(height: 16),
          _buildLegendItem(color: const Color(0xFF094174), text: "40%", subtext: "Interviewed"),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String text, required String subtext}) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                subtext,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
