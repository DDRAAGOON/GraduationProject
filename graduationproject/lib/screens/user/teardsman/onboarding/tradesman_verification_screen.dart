import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/screens/user/teardsman/nav_Botton_bar/nav_bottom_bar.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TradesmanVerificationScreen extends StatefulWidget {
  const TradesmanVerificationScreen({super.key});

  @override
  State<TradesmanVerificationScreen> createState() =>
      _TradesmanVerificationScreenState();
}

class _TradesmanVerificationScreenState
    extends State<TradesmanVerificationScreen> {
  static const String _visaKey = 'tradesman_verified_visa';
  static const String _tradesKey = 'tradesman_verified_trades';

  final List<String> _tradeOptions = [
    'نجار',
    'ميكانيكي',
    'كهربائي',
    'فني تكييف',
    'سباك',
    'دهان',
    'نجارة خشب',
    'تصليح أجهزة',
  ];

  final Set<String> _selectedTrades = <String>{};
  final TextEditingController _customTradeController = TextEditingController();
  String? _visaFileName;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  @override
  void dispose() {
    _customTradeController.dispose();
    super.dispose();
  }

  Future<void> _initializeState() async {
    await _loadSavedState();

    final prefs = await SharedPreferences.getInstance();
    final isCompleted =
        prefs.getBool('tradesman_verification_complete') ?? false;

    if (!mounted) return;

    if (isCompleted && (_visaFileName != null || _selectedTrades.isNotEmpty)) {
      final store = RecruitmentSyncStore.instance;
      store.updateUserProfile(
        fullName: store.currentUserName,
        title: _selectedTrades.join(', '),
        role: 'Tradesman',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Navbotton()),
      );
    }
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final savedVisa = prefs.getString(_visaKey);

    setState(() {
      _visaFileName = savedVisa != null && savedVisa.isNotEmpty
          ? savedVisa
          : null;
      _selectedTrades
        ..clear()
        ..addAll(prefs.getStringList(_tradesKey) ?? <String>[]);
    });
  }

  Future<void> _persistState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_visaKey, _visaFileName ?? '');
    await prefs.setStringList(_tradesKey, _selectedTrades.toList());
  }

  Future<void> _pickDocument({required String type}) async {
    setState(() => _isLoading = true);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.first;
      setState(() {
        if (type == 'visa') {
          _visaFileName = file.name;
        }
      });

      await _persistState();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addCustomTrade() async {
    final rawValue = _customTradeController.text.trim();
    if (rawValue.isEmpty) {
      return;
    }

    setState(() {
      _selectedTrades.add(rawValue);
      _customTradeController.clear();
    });

    await _persistState();
  }

  Future<void> _submit() async {
    if (_visaFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).tr(
              en: 'Please upload the visa/permit document before continuing.',
              ar: 'يرجى رفع ملف الفيش/الترخيص قبل المتابعة.',
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_selectedTrades.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).tr(
              en: 'Please select at least one trade before continuing.',
              ar: 'يرجى اختيار مهنة واحدة على الأقل قبل المتابعة.',
            ),
          ),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _persistState();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('tradesman_verification_complete', true);

      final store = RecruitmentSyncStore.instance;
      store.updateUserProfile(
        fullName: store.currentUserName,
        title: _selectedTrades.join(', '),
        role: 'Tradesman',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).tr(
                en: 'Tradesman verification saved successfully.',
                ar: 'تم حفظ بيانات الصنايعي بنجاح.',
              ),
            ),
            backgroundColor: Colors.green.shade700,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Navbotton()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t.tr(en: 'Trade verification', ar: 'التحقق من الصنايعي'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFFFB300),
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t.tr(
                          en: 'Warning: you must complete this registration before entering tradesman mode.',
                          ar: 'تنبيه: يجب إكمال هذه البيانات أولًا قبل الدخول لوضع الصنايعي.',
                        ),
                        style: const TextStyle(
                          color: Color(0xFF7A5600),
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                t.tr(en: 'Required documents', ar: 'المستندات المطلوبة'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                t.tr(
                  en: 'Upload your visa/permit to continue.',
                  ar: 'ارفع ملف الفيش/الترخيص للمتابعة.',
                ),
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.66),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.12),
                  ),
                ),
                child: _buildUploadCard(
                  title: t.tr(en: 'Visa / permit', ar: 'الفيش / الترخيص'),
                  subtitle: t.tr(
                    en: 'Upload your work visa or permit document',
                    ar: 'ارفع ملف الفيش أو الترخيص الخاص بك',
                  ),
                  fileName: _visaFileName,
                  onTap: () => _pickDocument(type: 'visa'),
                  icon: Icons.badge_outlined,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                t.tr(en: 'Select your profession', ar: 'اختر الحرفة الخاصة بك'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                t.tr(
                  en: 'Choose one or more trades you can work in.',
                  ar: 'اختر مهنة أو أكثر يمكنك العمل بها.',
                ),
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.66),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _tradeOptions.map((trade) {
                  final selected = _selectedTrades.contains(trade);
                  return FilterChip(
                    label: Text(trade),
                    selected: selected,
                    onSelected: (value) async {
                      setState(() {
                        if (value) {
                          _selectedTrades.add(trade);
                        } else {
                          _selectedTrades.remove(trade);
                        }
                      });
                      await _persistState();
                    },
                    backgroundColor: Theme.of(context).cardColor,
                    selectedColor: colorScheme.primary.withValues(alpha: 0.18),
                    checkmarkColor: colorScheme.primary,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customTradeController,
                      decoration: InputDecoration(
                        hintText: t.tr(
                          en: 'Add another profession',
                          ar: 'أضف حرفة أخرى',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _addCustomTrade,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(t.tr(en: 'Add', ar: 'إضافة')),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(t.tr(en: 'Continue', ar: 'متابعة')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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

  Widget _buildUploadCard({
    required String title,
    required String subtitle,
    required String? fileName,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fileName != null ? '$fileName ✓' : subtitle,
                    style: TextStyle(
                      color: fileName != null
                          ? Colors.green.shade700
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.55),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.cloud_upload_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
