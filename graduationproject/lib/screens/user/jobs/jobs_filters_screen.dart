import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class JobsFiltersScreen extends StatefulWidget {
  const JobsFiltersScreen({super.key});

  @override
  State<JobsFiltersScreen> createState() => _JobsFiltersScreenState();
}

class _JobsFiltersScreenState extends State<JobsFiltersScreen> {
  // State for expand/collapse
  bool _isEmploymentExpanded = false;
  bool _isSpecializationExpanded = false;
  bool _isLevelExpanded = false;
  bool _isSalaryExpanded = false;

  // State for checkboxes
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Filter",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          children: [
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
            const Divider(color: Colors.white12, height: 32),
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
            const Divider(color: Colors.white12, height: 32),
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
            const Divider(color: Colors.white12, height: 32),
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
            const SizedBox(height: 40),
            // Apply Filter Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF49769F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  "Apply Filter",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
            ],
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: 15),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 4,
            children: items,
          ),
        ],
      ],
    );
  }

  Widget _buildCheckbox(String label) {
    bool isSelected = _selectedFilters[label] ?? false;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilters[label] = !isSelected;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF49769F) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white38),
              ),
              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
