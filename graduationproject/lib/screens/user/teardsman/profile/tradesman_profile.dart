import 'package:flutter/material.dart';
import 'teardsman_data.dart';

class TradesmanProfile extends StatelessWidget {
  const TradesmanProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF011931),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Wallpaper and Profile Image
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 60),
                  decoration: const BoxDecoration(
                    color: Colors.white12,
                    image: DecorationImage(
                      image: AssetImage("assets/company/profile/1.png"), // Placeholder
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFF011931),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white12,
                    child: Icon(Icons.person, size: 70, color: Colors.white.withValues(alpha: 0.5)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              TradesmanProfileData.fullName,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              TradesmanProfileData.service,
              style: const TextStyle(color: Color(0xFF49769F), fontSize: 16),
            ),
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection("About Me", TradesmanProfileData.aboutMe),
                  const SizedBox(height: 20),
                  _buildContactInfo(),
                  const SizedBox(height: 20),
                  _buildSkillsSection(),
                  const SizedBox(height: 20),
                  _buildEducationSection(),
                  const SizedBox(height: 20),
                  _buildWorkShowcase(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          content.isEmpty ? "No information provided." : content,
          style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.phone, TradesmanProfileData.phone),
          const Divider(color: Colors.white12, height: 20),
          _buildInfoRow(Icons.email, TradesmanProfileData.email),
          const Divider(color: Colors.white12, height: 20),
          _buildInfoRow(Icons.location_on, TradesmanProfileData.address),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF49769F), size: 20),
        const SizedBox(width: 15),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Skills", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TradesmanProfileData.skills.map((skill) => Chip(
            label: Text(skill, style: const TextStyle(color: Colors.white, fontSize: 12)),
            backgroundColor: const Color(0xFF49769F).withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildEducationSection() {
    if (TradesmanProfileData.education.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Education", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...TradesmanProfileData.education.map((edu) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF49769F)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(edu['institution'] ?? "", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("${edu['degree']} (${edu['duration']})", style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildWorkShowcase() {
    if (TradesmanProfileData.workImages.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Work Showcase", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: TradesmanProfileData.workImages.length,
            itemBuilder: (context, index) => Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage("assets/company/profile/6.png"), // Placeholder
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

