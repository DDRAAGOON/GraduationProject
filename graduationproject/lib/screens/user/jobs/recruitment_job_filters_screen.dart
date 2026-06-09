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
    _selectedType = _ensureValueExists(store.filterType, [
      'All',
      'Full-time',
      'Part-time',
      'Remote',
    ]);
    _selectedCategory = _ensureValueExists(
      store.filterCategory,
      RecruitmentSyncStore.categories,
    );
    _selectedSalary = _ensureValueExists(
      store.filterSalaryRange,
      RecruitmentSyncStore.salaryRanges,
    );
  }

  String _ensureValueExists(String value, List<String> items) {
    if (items.contains(value)) return value;
    return items.isNotEmpty ? items.first : 'All';
  }

  String _translateLabel(String label, bool isAr) {
    if (!isAr) return label;
    final low = label.trim().toLowerCase();
    switch (low) {
      case 'all':
        return 'الكل';
      case 'full-time':
      case 'full time':
        return 'دوام كامل';
      case 'part-time':
      case 'part time':
        return 'دوام جزئي';
      case 'remote':
        return 'عن بعد';
      case 'technical':
        return 'تقني';
      case 'non-technical':
        return 'غير تقني';
      case 'service':
      case 'services':
        return 'خدمة';
      case 'tradesman':
        return 'حرفي';
      case 'negotiable':
        return 'قابل للتفاوض';
      default:
        // Handle salary ranges if needed, e.g., '10k - 20k' stays same or format it
        return label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF001E3A)
        : const Color(0xFFF8FBF4);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          isAr ? 'فلاتر متقدمة' : 'Advanced Filters',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF7A2A),
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterLabel(isAr ? 'نوع التوظيف' : 'Employment Type'),
              const SizedBox(height: 10),
              _buildDropdown(
                value: _selectedType,
                items: ['All', 'Full-time', 'Part-time', 'Remote'],
                isAr: isAr,
                onChanged: (value) =>
                    setState(() => _selectedType = value ?? 'All'),
              ),
              const SizedBox(height: 24),

              _buildFilterLabel(isAr ? 'نطاق الراتب' : 'Salary Range'),
              const SizedBox(height: 10),
              _buildDropdown(
                value: _selectedSalary,
                items: RecruitmentSyncStore.salaryRanges,
                isAr: isAr,
                onChanged: (value) =>
                    setState(() => _selectedSalary = value ?? 'All'),
              ),
              const SizedBox(height: 24),

              _buildFilterLabel(isAr ? 'التصنيفات' : 'Categories'),
              const SizedBox(height: 10),
              _buildDropdown(
                value: _selectedCategory,
                items: RecruitmentSyncStore.categories,
                isAr: isAr,
                onChanged: (value) =>
                    setState(() => _selectedCategory = value ?? 'All'),
              ),

              const SizedBox(height: 48),
              AppButton(
                label: isAr ? 'تطبيق الفلاتر' : 'Apply Filters',
                backgroundColor: const Color(0xFF142C66),
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
                  child: Text(
                    isAr ? 'إعادة ضبط الكل' : 'Reset All',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
      style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 15,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required bool isAr,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        initialValue: items.contains(value) ? value : items.first,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 14,
        ),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Theme.of(context).colorScheme.outline,
        ),
        dropdownColor: Theme.of(context).colorScheme.surface,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  _translateLabel(e, isAr), // ترجمة النص الظاهر في القائمة
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
