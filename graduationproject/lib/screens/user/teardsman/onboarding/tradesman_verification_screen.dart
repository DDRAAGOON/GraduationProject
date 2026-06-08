import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/screens/user/teardsman/nav_Botton_bar/nav_bottom_bar.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/services/auth_service.dart';
import '../../../../shared/services/user_service.dart';

class TradesmanVerificationScreen extends StatefulWidget {
  const TradesmanVerificationScreen({super.key});

  @override
  State<TradesmanVerificationScreen> createState() =>
      _TradesmanVerificationScreenState();
}

class _TradesmanVerificationScreenState
    extends State<TradesmanVerificationScreen> {
  final List<String> _tradeOptions = [
    'كهربائي',
    'فني سباكة',
    'نجار',
    'نقاش',
    'ميكانيكي',
    'حداد',
    'فني تكييف',
  ];

  final Set<String> _selectedTrades = <String>{};
  final TextEditingController _customTradeController = TextEditingController();
  String? _fishFileName;
  String? _fishFilePath;
  bool _isLoading = false;

  Future<void> _pickDocument() async {
    setState(() => _isLoading = true);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _fishFileName = result.files.first.name;
          _fishFilePath = result.files.first.path;
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addCustomTrade() {
    final text = _customTradeController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _selectedTrades.add(text);
        _customTradeController.clear();
      });
    }
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context);

    if (_fishFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.tr(
              en: "Please upload your criminal record",
              ar: "يرجى رفع صحيفة الحالة الجنائية أولاً",
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
            t.tr(
              en: "Please select at least one service",
              ar: "يرجى اختيار خدمة واحدة على الأقل",
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final store = RecruitmentSyncStore.instance;
    final prefs = await SharedPreferences.getInstance();

    try {
      String? documentUrl;
      // Upload the document
      if (_fishFilePath != null) {
        documentUrl = await AuthService.instance.uploadDocument(_fishFilePath!);
      }

      // Update the user profile on the backend
      await UserService.instance.updateProfile(
        services: _selectedTrades.toList(),
        criminalRecordUrl: documentUrl,
        classification: 'tradesman_work',
      );

      // Save with email-specific key
      await prefs.setBool(
        'is_tradesman_verified_${store.currentUserEmail}',
        true,
      );

      // Update local store
      store.updateUserProfile(
        fullName: store.currentUserName,
        title: _selectedTrades.join(', '),
        role: 'Tradesman',
        tradesmanServices: _selectedTrades.toList(),
      );

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Navbotton()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.tr(
                en: 'Failed to update data: $e',
                ar: 'حدث خطأ أثناء رفع البيانات: $e',
              ),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurfaceColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF001E3A)
          : const Color(0xFFF8FBF4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: onSurfaceColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t.tr(en: "Complete Data", ar: "إكمال البيانات"),
          style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Warning Box (Yellow Message)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.tr(
                        en: "Warning: You must complete your data (Criminal Record and Services) to switch to Tradesman Mode.",
                        ar: "تنبيه: يجب إكمال بياناتك (الصحيفة الجنائية والخدمات) لتتمكن من التبديل لوضع الحرفي.",
                      ),
                      style: TextStyle(
                        color: isDark
                            ? Colors.amber[100]
                            : const Color(0xFF856404),
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 2. Upload Section (Criminal Record)
            Text(
              t.tr(
                en: "Criminal Record (Fish)",
                ar: "صحيفة الحالة الجنائية (فيش و تشبيه)",
              ),
              style: TextStyle(
                color: onSurfaceColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickDocument,
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _fishFileName != null
                        ? Colors.green
                        : onSurfaceColor.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _fishFileName != null
                          ? Icons.check_circle
                          : Icons.cloud_upload_outlined,
                      color: _fishFileName != null
                          ? Colors.green
                          : const Color(0xFF0051DD),
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _fishFileName ??
                          (isAr ? "اضغط لرفع الملف" : "Click to upload file"),
                      style: TextStyle(
                        color: _fishFileName != null
                            ? Colors.green
                            : onSurfaceColor.withOpacity(0.5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 3. Services Selection
            Text(
              t.tr(en: "Select Service", ar: "اختر الخدمة"),
              style: TextStyle(
                color: onSurfaceColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _tradeOptions.map((trade) {
                final isSelected = _selectedTrades.contains(trade);
                return GestureDetector(
                  onTap: () => setState(
                    () => isSelected
                        ? _selectedTrades.remove(trade)
                        : _selectedTrades.add(trade),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0051DD)
                          : (isDark ? const Color(0xFF0D2D4D) : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : onSurfaceColor.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected)
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        if (isSelected) const SizedBox(width: 8),
                        Text(
                          trade,
                          style: TextStyle(
                            color: isSelected ? Colors.white : onSurfaceColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // 4. Custom Service
            Text(
              t.tr(en: "Write another service", ar: "اكتب خدمة اخرى"),
              style: TextStyle(
                color: onSurfaceColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customTradeController,
                    style: TextStyle(color: onSurfaceColor),
                    decoration: InputDecoration(
                      hintText: t.tr(en: "Type here...", ar: "اكتب هنا..."),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF0D2D4D)
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _addCustomTrade,
                  icon: const Icon(
                    Icons.add_circle,
                    color: Color(0xFF0051DD),
                    size: 36,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),

            // 5. Buttons (Confirm & Cancel)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      t.cancel,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF0051DD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            t.tr(en: "Confirm", ar: "تأكيد"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
