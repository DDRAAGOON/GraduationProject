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
    _selectedType = store.filterType;
    _selectedCategory = store.filterCategory;
    _selectedSalary = store.filterSalaryRange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Filters'),
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Employment Type',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const ['All', 'Full-time', 'Part-time','Remote']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value ?? 'All'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Salary Range',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedSalary,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: RecruitmentSyncStore.salaryRanges
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedSalary = value ?? 'All'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Categories',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: RecruitmentSyncStore.categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value ?? 'All'),
              ),
              const SizedBox(height: 40),
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
              const SizedBox(height: 10),
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
                  child: const Text('Reset All'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
