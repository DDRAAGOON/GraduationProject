import 'package:flutter/material.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_button.dart';

class RecruitmentJobFiltersScreen extends StatefulWidget {
  const RecruitmentJobFiltersScreen({super.key});

  @override
  State<RecruitmentJobFiltersScreen> createState() =>
      _RecruitmentJobFiltersScreenState();
}

class _RecruitmentJobFiltersScreenState
    extends State<RecruitmentJobFiltersScreen> {
  late String _selectedType;
  late String _selectedCategory;
  late String _selectedSalary;

  @override
  void initState() {
    super.initState();
    final store = RecruitmentSyncStore.instance;
    
    // Safely initialize values
    _selectedType = _ensureValueExists(store.filterType, ['All', 'Full-time', 'Part-time', 'Remote', 'Contract']);
    _selectedCategory = _ensureValueExists(store.filterCategory, RecruitmentSyncStore.categories);
    _selectedSalary = _ensureValueExists(store.filterSalaryRange, RecruitmentSyncStore.salaryRanges);
  }

  String _ensureValueExists(String value, List<String> items) {
    if (items.contains(value)) return value;
    return items.isNotEmpty ? items.first : 'All';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        title: const Text('Advanced Filters', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF9F5F1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterLabel('Employment Type'),
              const SizedBox(height: 10),
              _buildDropdown(
                value: _selectedType,
                items: ['All', 'Full-time', 'Part-time', 'Remote', 'Contract'],
                onChanged: (value) => setState(() => _selectedType = value ?? 'All'),
              ),
              const SizedBox(height: 24),
              
              _buildFilterLabel('Salary Range'),
              const SizedBox(height: 10),
              _buildDropdown(
                value: _selectedSalary,
                items: RecruitmentSyncStore.salaryRanges,
                onChanged: (value) => setState(() => _selectedSalary = value ?? 'All'),
              ),
              const SizedBox(height: 24),
              
              _buildFilterLabel('Categories'),
              const SizedBox(height: 10),
              _buildDropdown(
                value: _selectedCategory,
                items: RecruitmentSyncStore.categories,
                onChanged: (value) => setState(() => _selectedCategory = value ?? 'All'),
              ),
              
              const SizedBox(height: 48),
              AppButton(
                label: 'Apply Filters',
                onPressed: () {
                  RecruitmentSyncStore.instance.updateFilters(
                    type: _selectedType,
                    category: _selectedCategory,
                    salaryRange: _selectedSalary,
                  );
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedType = 'All';
                      _selectedCategory = 'All';
                      _selectedSalary = 'All';
                    });
                  },
                  child: const Text('Reset All', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF011931)),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : items.first,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
