import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../notifications/notifications_screen.dart';
import '../settings/setting_screen.dart';

class TechnicalScreen extends StatefulWidget {
  const TechnicalScreen({super.key});

  @override
  State<TechnicalScreen> createState() => _TechnicalScreenState();
}

class _TechnicalScreenState extends State<TechnicalScreen> {
  bool _isEmploymentExpanded = false;
  bool _isSpecializationExpanded = false;
  bool _isLevelExpanded = false;
  bool _isSalaryExpanded = false;

  String _selectedCategory = "technical";

  final Map<String, bool> _selectedFilters = {
    "Full-time (3)": true, "Part-Time (5)": false, "Remote (2)": false,
    "Internship (24)": false, "Contract (3)": false, "Design (24)": true,
    "Sales (3)": false, "Marketing (3)": true, "Business (3)": false,
    "Human Resource (6)": false, "Entry Level (57)": false, "Mid Level (3)": false,
    "Senior Level (5)": true, "Director (12)": false, "VP or Above (8)": false,
    "\$700 - \$1000 (4)": false, "\$1000 - \$1500 (8)": false,
    "\$1500 - \$2000 (10)": false, "\$3000 or above (4)": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildTopBar(),
              const SizedBox(height: 20),
              _buildSearchSection(),
              const SizedBox(height: 15),
              const Text("Popular : UI Designer, UX Researcher, Android, Admin", style: TextStyle(color: Colors.white38, fontSize: 11)),
              const SizedBox(height: 25),

              // Filter Grid (Two side-by-side)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildFilterSection(
                      title: "Type of Employment",
                      isExpanded: _isEmploymentExpanded,
                      onToggle: () => setState(() => _isEmploymentExpanded = !_isEmploymentExpanded),
                      items: ["Full-time (3)", "Part-Time (5)", "Remote (2)", "Internship (24)", "Contract (3)"],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildFilterSection(
                      title: "Specialization",
                      isExpanded: _isSpecializationExpanded,
                      onToggle: () => setState(() => _isSpecializationExpanded = !_isSpecializationExpanded),
                      items: ["Design (24)", "Sales (3)", "Marketing (3)", "Business (3)", "Human Resource (6)"],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildFilterSection(
                      title: "Experience Level",
                      isExpanded: _isLevelExpanded,
                      onToggle: () => setState(() => _isLevelExpanded = !_isLevelExpanded),
                      items: ["Entry Level (57)", "Mid Level (3)", "Senior Level (5)", "Director (12)", "VP or Above (8)"],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildFilterSection(
                      title: "Salary Range",
                      isExpanded: _isSalaryExpanded,
                      onToggle: () => setState(() => _isSalaryExpanded = !_isSalaryExpanded),
                      items: ["\$700 - \$1000 (4)", "\$1000 - \$1500 (8)", "\$1500 - \$2000 (10)", "\$3000 or above (4)"],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 25),
              const Text("Explore By Category", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildCategoryTabs(),
              const SizedBox(height: 25),
              _buildDynamicJobSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildTopIconButton(Icons.notifications_none, hasBadge: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()))),
        const SizedBox(width: 12),
        _buildTopIconButton(Icons.settings_outlined, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()))),
      ],
    );
  }

  Widget _buildTopIconButton(IconData icon, {bool hasBadge = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: const Color(0xFF0D2D4D), shape: BoxShape.circle, border: Border.all(color: Colors.white12)),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          if (hasBadge) Positioned(right: 12, top: 10, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white12)),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Colors.white54, size: 18),
          const Expanded(child: TextField(style: TextStyle(color: Colors.white, fontSize: 13), decoration: InputDecoration(hintText: "Search jobs", hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none))),
          Container(height: 20, width: 1, color: Colors.white24),
          const SizedBox(width: 12),
          const Icon(Icons.location_on_outlined, color: Colors.white54, size: 18),
          const Text("Florence", style: TextStyle(color: Colors.white70, fontSize: 12)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
          const SizedBox(width: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: const Color(0xFF49769F), borderRadius: BorderRadius.circular(20)), child: const Text("Search", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    const tabBarHorizontalPadding = 5.0;
    const tabBarVerticalPadding = 6.0;
    const betweenTabs = 10.0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: tabBarHorizontalPadding,
        vertical: tabBarVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTabItem("Technical")),
          const SizedBox(width: betweenTabs),
          Expanded(child: _buildTabItem("NonTechnical")),
          const SizedBox(width: betweenTabs),
          Expanded(child: _buildTabItem("Serves")),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label) {
    bool isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF001E3A) : const Color(0xFFBDD8E9),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF094174),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection({required String title, required bool isExpanded, required VoidCallback onToggle, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)),
              Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white, size: 18),
            ],
          ),
        ),
        if (isExpanded)
          Column(
            children: [
              const SizedBox(height: 10),
              ...items.map((item) => _buildCheckbox(item)),
            ],
          ),
      ],
    );
  }

  Widget _buildCheckbox(String label) {
    bool isSelected = _selectedFilters[label] ?? false;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilters[label] = !isSelected),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Container(
              width: 16, height: 16,
              decoration: BoxDecoration(color: isSelected ? const Color(0xFF49769F) : Colors.transparent, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.white38)),
              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicJobSection() {
    if (_selectedCategory == "technical") {
      return Column(
        children: [
          _buildSectionHeader("Special jobs"),
          const SizedBox(height: 15),
          _buildJobCard(
            title: "Social Media Assistant",
            company: "Nomad",
            location: "Paris, France",
            applied: 4,
            capacity: 18,
          ),
          _buildJobCard(
            title: "Interactive Developer",
            company: "Terraform",
            location: "Hamburg, Germany",
            applied: 8,
            capacity: 12,
          ),
          _buildJobCard(
            title: "Brand Designer",
            company: "Dropbox",
            location: "San Fransisco, USA",
            applied: 2,
            capacity: 10,
          ),
          const SizedBox(height: 30),
          _buildSectionHeader("Today jobs"),
          const SizedBox(height: 15),
          _buildJobCard(
            title: "Email Marketing",
            company: "Revolut",
            location: "Madrid, Spain",
            applied: 0,
            capacity: 10,
          ),
          _buildJobCard(
            title: "Lead Engineer",
            company: "Canva",
            location: "Ankara, Turkey",
            applied: 4,
            capacity: 10,
          ),
          _buildJobCard(
            title: "Product Designer",
            company: "ClassPass",
            location: "Berlin, Germany",
            applied: 4,
            capacity: 10,
          ),
          _buildJobCard(
            title: "Customer Manager",
            company: "Pitch",
            location: "Berlin, Germany",
            applied: 4,
            capacity: 10,
          ),
        ],
      );
    } else if (_selectedCategory == "NonTechnical") {
      return Column(
        children: [
          _buildSectionHeader("Special jobs"),
          const SizedBox(height: 15),
          _buildJobCard(
            title: "HR Manager",
            company: "LinkedIn",
            location: "London, UK",
            applied: 5,
            capacity: 10,
          ),
          _buildJobCard(
            title: "Sales Executive",
            company: "Amazon",
            location: "Berlin, Germany",
            applied: 12,
            capacity: 20,
          ),
          _buildJobCard(
            title: "Office Administrator",
            company: "Google",
            location: "Dublin, Ireland",
            applied: 3,
            capacity: 5,
          ),
          const SizedBox(height: 30),
          _buildSectionHeader("Today jobs"),
          const SizedBox(height: 15),
          _buildJobCard(
            title: "Marketing Coordinator",
            company: "Facebook",
            location: "Menlo Park, USA",
            applied: 8,
            capacity: 15,
          ),
          _buildJobCard(
            title: "Content Writer",
            company: "Medium",
            location: "Remote",
            applied: 20,
            capacity: 50,
          ),
          _buildJobCard(
            title: "Customer Success",
            company: "Zendesk",
            location: "Copenhagen, Denmark",
            applied: 6,
            capacity: 10,
          ),
        ],
      );
    } else {
      // Serves category
      return Column(
        children: [
          _buildSectionHeader("Special jobs"),
          const SizedBox(height: 15),
          _buildJobCard(
            title: "Hotel Receptionist",
            company: "Marriott",
            location: "Paris, France",
            applied: 4,
            capacity: 10,
          ),
          _buildJobCard(
            title: "Delivery Driver",
            company: "Uber",
            location: "Madrid, Spain",
            applied: 50,
            capacity: 100,
          ),
          _buildJobCard(
            title: "Security Guard",
            company: "Brinks",
            location: "Ankara, Turkey",
            applied: 2,
            capacity: 10,
          ),
          const SizedBox(height: 30),
          _buildSectionHeader("Today jobs"),
          const SizedBox(height: 15),
          _buildJobCard(
            title: "Cleaning Staff",
            company: "CleanHome",
            location: "Berlin, Germany",
            applied: 5,
            capacity: 20,
          ),
          _buildJobCard(
            title: "Barista",
            company: "Starbucks",
            location: "Rome, Italy",
            applied: 10,
            capacity: 15,
          ),
          _buildJobCard(
            title: "Waiter/Waitress",
            company: "Local Restaurant",
            location: "Florence, Italy",
            applied: 4,
            capacity: 10,
          ),
        ],
      );
    }
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: title.split(' ')[0]),
              const TextSpan(text: " "),
              TextSpan(text: title.split(' ')[1], style: const TextStyle(color: Color(0xFF49769F))),
            ],
          ),
        ),
        Row(
          children: [
            const Text("Show all jobs", style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward, color: Colors.white54, size: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildJobCard({
    required String title,
    required String company,
    required String location,
    required int applied,
    required int capacity,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.business, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                Text("$company • $location", style: const TextStyle(color: Colors.white38, fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildTag("Full-Time"),
                    _buildTag("Marketing", isHighlighted: true),
                    _buildTag("Design"),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF49769F),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("Apply", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: applied / capacity,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("$applied applied of $capacity capacity", style: const TextStyle(color: Colors.white38, fontSize: 9)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, {bool isHighlighted = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFF0D2D4D) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isHighlighted ? Colors.orange.withOpacity(0.5) : Colors.white12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isHighlighted ? Colors.orange : Colors.white70,
          fontSize: 10,
        ),
      ),
    );
  }
}
