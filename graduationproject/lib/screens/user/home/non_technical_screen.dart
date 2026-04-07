import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../../../constants/app_images.dart';
import '../jobs/jobs_filters_screen.dart';
import 'services_Screen.dart';
import 'technical_screen.dart';

class NonTechnicalScreen extends StatefulWidget {
  const NonTechnicalScreen({super.key});

  @override
  State<NonTechnicalScreen> createState() => _NonTechnicalScreenState();
}

class _NonTechnicalScreenState extends State<NonTechnicalScreen> {
  // State for expand/collapse (using the same logic from technical screen)
  bool _isEmploymentExpanded = false;
  bool _isSpecializationExpanded = false;
  bool _isLevelExpanded = false;
  bool _isSalaryExpanded = false;

  // Selected Category
  final String _selectedCategory = "NonTechnical";

  final Map<String, bool> _selectedFilters = {
    "Full-time (3)": true,
    "Part-Time (5)": false,
    "Remote (2)": false,
    "Internship (24)": false,
    "Contract (3)": false,
    "Design (24)": true,
    "Sales (3)": false,
    "Marketing (3)": true,
    "Business (3)": false,
    "Human Resource (6)": false,
    "Entry Level (57)": false,
    "Mid Level (3)": false,
    "Senior Level (5)": true,
    "Director (12)": false,
    "VP or Above (8)": false,
    "\$700 - \$1000 (4)": false,
    "\$1000 - \$1500 (8)": false,
    "\$1500 - \$2000 (10)": false,
    "\$3000 or above (4)": false,
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
              // Top Bar Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildTopIconButton(Icons.notifications_none, hasBadge: true),
                  const SizedBox(width: 12),
                  _buildTopIconButton(Icons.settings_outlined, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JobsFiltersScreen()),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),

              // Search Section
              _buildSearchSection(),
              const SizedBox(height: 15),

              // Popular Tags
              const Text(
                "Popular : UI Designer, UX Researcher, Android, Admin",
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
              const SizedBox(height: 25),

              // Filters (Using the dynamic logic)
              _buildFilterSection(
                title: "Type of Employment",
                isExpanded: _isEmploymentExpanded,
                onToggle: () => setState(() => _isEmploymentExpanded = !_isEmploymentExpanded),
                items: [
                  _buildCheckbox("Full-time (3)"),
                  _buildCheckbox("Part-Time (5)"),
                  _buildCheckbox("Remote (2)"),
                  _buildCheckbox("Internship (24)"),
                  _buildCheckbox("Contract (3)"),
                ],
              ),
              _buildFilterSection(
                title: "Specialization",
                isExpanded: _isSpecializationExpanded,
                onToggle: () => setState(() => _isSpecializationExpanded = !_isSpecializationExpanded),
                items: [
                  _buildCheckbox("Design (24)"),
                  _buildCheckbox("Sales (3)"),
                  _buildCheckbox("Marketing (3)"),
                  _buildCheckbox("Business (3)"),
                  _buildCheckbox("Human Resource (6)"),
                ],
              ),
              _buildFilterSection(
                title: "Experience Level",
                isExpanded: _isLevelExpanded,
                onToggle: () => setState(() => _isLevelExpanded = !_isLevelExpanded),
                items: [
                  _buildCheckbox("Entry Level (57)"),
                  _buildCheckbox("Mid Level (3)"),
                  _buildCheckbox("Senior Level (5)"),
                  _buildCheckbox("Director (12)"),
                  _buildCheckbox("VP or Above (8)"),
                ],
              ),
              _buildFilterSection(
                title: "Salary Range",
                isExpanded: _isSalaryExpanded,
                onToggle: () => setState(() => _isSalaryExpanded = !_isSalaryExpanded),
                items: [
                  _buildCheckbox("\$700 - \$1000 (4)"),
                  _buildCheckbox("\$1000 - \$1500 (8)"),
                  _buildCheckbox("\$1500 - \$2000 (10)"),
                  _buildCheckbox("\$3000 or above (4)"),
                ],
              ),

              const SizedBox(height: 30),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 25),

              // Explore By Category
              const Text(
                "Explore By Category",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildCategoryTabs(),
              const SizedBox(height: 25),

              // Special Jobs Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Special jobs", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  TextButton.icon(
                    onPressed: () {},
                    label: const Icon(Icons.arrow_forward, color: Color(0xFF49769F), size: 16),
                    icon: const Text("Show all jobs", style: TextStyle(color: Color(0xFF49769F), fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Different jobs for Non-Technical category
              _buildJobCard(title: "HR Manager", applied: 2, capacity: 5),
              _buildJobCard(title: "Sales Executive", applied: 10, capacity: 15),
              _buildJobCard(title: "Business Analyst", applied: 5, capacity: 10),

              const SizedBox(height: 25),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 25),

              // Today Jobs Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Today jobs", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  TextButton.icon(
                    onPressed: () {},
                    label: const Icon(Icons.arrow_forward, color: Color(0xFF49769F), size: 16),
                    icon: const Text("Show all jobs", style: TextStyle(color: Color(0xFF49769F), fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildJobCard(title: "Accountant", applied: 1, capacity: 3),
              _buildJobCard(title: "Office Administrator", applied: 4, capacity: 10),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopIconButton(IconData icon, {bool hasBadge = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
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
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Colors.white54, size: 18),
          const Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: "Job title or keyword",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(height: 20, width: 1, color: Colors.white24),
          const SizedBox(width: 12),
          const Icon(Icons.location_on_outlined, color: Colors.white54, size: 18),
          const Text("Florence, Italy", style: TextStyle(color: Colors.white70, fontSize: 12)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF49769F),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("Search", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildTabItem("technical"),
          _buildTabItem("NonTechnical"),
          _buildTabItem("Serves"),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label) {
    bool isSelected = _selectedCategory == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (label == "technical") {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TechnicalScreen()));
          } else if (label == "Serves") {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ServicesScreen()));
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF001E3A) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard({required String title, required int applied, required int capacity}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.business, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const Text("Nomad • Paris, France", style: TextStyle(color: Colors.white38, fontSize: 12)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildTag("Full-Time"),
                    _buildTag("Marketing", isHighlight: true),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF49769F),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("Apply", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  value: applied / capacity,
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                ),
              ),
              Text("$applied applied of $capacity capacity", style: const TextStyle(color: Colors.white38, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, {bool isHighlight = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFF0D2D4D) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isHighlight ? Colors.orange : Colors.white12),
      ),
      child: Text(label, style: TextStyle(color: isHighlight ? Colors.orange : Colors.white54, fontSize: 10)),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> items,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onToggle,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          ),
        ),
        if (isExpanded)
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 4,
            children: items,
          ),
      ],
    );
  }

  Widget _buildCheckbox(String label) {
    bool isSelected = _selectedFilters[label] ?? false;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilters[label] = !isSelected),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18, height: 18,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF49769F) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white38),
            ),
            child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
