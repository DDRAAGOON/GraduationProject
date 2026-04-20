import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
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
  bool _isSalaryExpanded = false;

  String _selectedCategory = "technical";
  String _selectedLocation = "Cairo";
  final TextEditingController _searchController = TextEditingController();

  final List<String> _egyptGovernorates = [
    "Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Fayoum", 
    "Gharbia", "Ismailia", "Monufia", "Minya", "Qalyubia", "New Valley", 
    "Sharqia", "Suez", "Aswan", "Assiut", "Beni Suef", "Port Said", 
    "Damietta", "South Sinai", "Kafr El Sheikh", "Matrouh", "Luxor", "Qena", "Sohag", "North Sinai"
  ];

  final List<Map<String, dynamic>> _allJobs = [
    {"title": "Social Media Assistant", "company": "Nomad", "location": "Paris, France", "applied": 4, "capacity": 18, "category": "technical"},
    {"title": "Interactive Developer", "company": "Terraform", "location": "Hamburg, Germany", "applied": 8, "capacity": 12, "category": "technical"},
    {"title": "Brand Designer", "company": "Dropbox", "location": "San Fransisco, USA", "applied": 2, "capacity": 10, "category": "technical"},
    {"title": "Email Marketing", "company": "Revolut", "location": "Madrid, Spain", "applied": 0, "capacity": 10, "category": "technical"},
    {"title": "Lead Engineer", "company": "Canva", "location": "Ankara, Turkey", "applied": 4, "capacity": 10, "category": "technical"},
    {"title": "HR Manager", "company": "LinkedIn", "location": "London, UK", "applied": 5, "capacity": 10, "category": "nontechnical"},
    {"title": "Sales Executive", "company": "Amazon", "location": "Berlin, Germany", "applied": 12, "capacity": 20, "category": "nontechnical"},
    {"title": "Marketing Coordinator", "company": "Facebook", "location": "Menlo Park, USA", "applied": 8, "capacity": 15, "category": "nontechnical"},
    {"title": "Hotel Receptionist", "company": "Marriott", "location": "Paris, France", "applied": 4, "capacity": 10, "category": "services"},
    {"title": "Delivery Driver", "company": "Uber", "location": "Madrid, Spain", "applied": 50, "capacity": 100, "category": "services"},
    {"title": "Barista", "company": "Starbucks", "location": "Rome, Italy", "applied": 10, "capacity": 15, "category": "services"},
  ];

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 25),
              _buildSearchSection(),
              const SizedBox(height: 15),
              const Text("Popular : UI Designer, UX Researcher, Android, Admin", 
                style: TextStyle(color: Colors.white38, fontSize: 11)),
              const SizedBox(height: 25),

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
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: "Explore By ", style: TextStyle(color: Colors.white)),
                    TextSpan(text: "Category", style: TextStyle(color: Color(0xFF578BC7))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
        _buildTopIconButton(Icons.notifications_none, 
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()))),
        const SizedBox(width: 12),
        _buildTopIconButton(Icons.settings_outlined, 
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()))),
      ],
    );
  }

  Widget _buildTopIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF0D2D4D), 
          shape: BoxShape.circle, 
          border: Border.all(color: Colors.white12)
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05), 
        borderRadius: BorderRadius.circular(30), 
        border: Border.all(color: Colors.white12)
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Colors.white54, size: 18),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              style: const TextStyle(color: Colors.white, fontSize: 13), 
              decoration: const InputDecoration(
                hintText: "Search jobs", 
                hintStyle: TextStyle(color: Colors.white38), 
                border: InputBorder.none
              )
            )
          ),
          Container(height: 20, width: 1, color: Colors.white24),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _showLocationPicker,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.white54, size: 18),
                const SizedBox(width: 4),
                Text(_selectedLocation, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
            decoration: BoxDecoration(color: const Color(0xFF49769F), borderRadius: BorderRadius.circular(20)), 
            child: const Text("Search", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))
          ),
        ],
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D2D4D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Select Governorate", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _egyptGovernorates.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_egyptGovernorates[index], style: const TextStyle(color: Colors.white70)),
                    onTap: () {
                      setState(() => _selectedLocation = _egyptGovernorates[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryTabs() {
    return Row(
      children: [
        Expanded(child: _buildTabItem("Technical", "technical", Bootstrap.laptop, const Color(0xFF6C63FF))),
        const SizedBox(width: 10),
        Expanded(child: _buildTabItem("Non-Technical", "nontechnical", FontAwesome.user_tie_solid, const Color(0xFF4CAF50))),
        const SizedBox(width: 10),
        Expanded(child: _buildTabItem("Services", "services", Bootstrap.bell, const Color(0xFFFF9800))),
      ],
    );
  }

  Widget _buildTabItem(String label, String value, IconData icon, Color activeColor) {
    bool isSelected = _selectedCategory == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = value),
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutQuart,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : const Color(0xFF0D2D4D),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: isSelected ? Colors.white54 : Colors.white10),
            boxShadow: isSelected ? [
              BoxShadow(
                color: activeColor.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              )
            ] : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white54,
                size: 28,
              ),
              const SizedBox(height: 15),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
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
    final String query = _searchController.text.toLowerCase();
    
    final List<Map<String, dynamic>> categoryJobs = _allJobs
        .where((job) => job["category"] == _selectedCategory && 
                job["title"].toString().toLowerCase().contains(query))
        .toList();

    if (categoryJobs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text("No jobs found matching your search", style: TextStyle(color: Colors.white54, fontSize: 14)),
        ),
      );
    }

    return Column(
      children: [
        _buildSectionHeader("All jobs"),
        const SizedBox(height: 15),
        ...categoryJobs.map((job) => _buildJobCard(
          title: job["title"],
          company: job["company"],
          location: job["location"],
          applied: job["applied"],
          capacity: job["capacity"],
        )),
      ],
    );
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
          children: const [
            Text("Show all jobs", style: TextStyle(color: Colors.white54, fontSize: 12)),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward, color: Colors.white54, size: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildJobCard({required String title, required String company, required String location, required int applied, required int capacity}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.business, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                Text("$company â€¢ $location", style: const TextStyle(color: Colors.white38, fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildTag("Full-Time"),
                    _buildTag("Marketing", isHighlighted: true),
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
                decoration: BoxDecoration(color: const Color(0xFF49769F), borderRadius: BorderRadius.circular(20)),
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
        border: Border.all(color: isHighlighted ? Colors.orange.withValues(alpha: 0.5) : Colors.white12),
      ),
      child: Text(
        text,
        style: TextStyle(color: isHighlighted ? Colors.orange : Colors.white70, fontSize: 10),
      ),
    );
  }
}

