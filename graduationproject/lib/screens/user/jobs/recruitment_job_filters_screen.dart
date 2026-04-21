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
  late String _selectedLocation;

  @override
  void initState() {
    super.initState();
    final store = RecruitmentSyncStore.instance;
    _selectedType = store.filterType;
    _selectedLocation = store.filterLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Filters')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(labelText: 'Employment Type'),
              items: const ['All', 'Full-time', 'Part-time', 'Contract']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedType = value ?? 'All'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedLocation,
              decoration: const InputDecoration(labelText: 'Location'),
              items: const ['All', 'Remote', 'Cairo, Egypt', 'Alex, Egypt']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedLocation = value ?? 'All'),
            ),
            const Spacer(),
            AppButton(
              label: 'Apply Filters',
              onPressed: () {
                RecruitmentSyncStore.instance.updateFilters(
                  type: _selectedType,
                  location: _selectedLocation,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
