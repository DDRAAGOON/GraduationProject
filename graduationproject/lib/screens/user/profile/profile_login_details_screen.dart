import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';
import 'edit_profile_screen.dart';
import 'setting_profile/notifications.dart';
import 'setting_profile/preferences.dart';

class ProfileLoginDetailsScreen extends StatefulWidget {
  const ProfileLoginDetailsScreen({super.key});

  @override
  State<ProfileLoginDetailsScreen> createState() => _ProfileLoginDetailsScreenState();
}

class _ProfileLoginDetailsScreenState extends State<ProfileLoginDetailsScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    final t = AppLocalizations.of(context);
    final current = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      _showError(t.tr(en: "Please fill all fields", ar: "يرجى ملء جميع الحقول"));
      return;
    }

    if (newPass.length < 8) {
      _showError(t.tr(en: "New password must be at least 8 characters", ar: "يجب أن تكون كلمة المرور الجديدة 8 أحرف على الأقل"));
      return;
    }

    if (newPass != confirm) {
      _showError(t.tr(en: "Passwords do not match", ar: "كلمات المرور غير متطابقة"));
      return;
    }

    // Success simulation for the project
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.tr(en: "Password Updated Successfully!", ar: "تم تحديث كلمة المرور بنجاح!")),
        backgroundColor: Colors.green,
      ),
    );
    
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
    final onSurfaceColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          t.tr(en: "Edit Profile", ar: "تعديل الملف الشخصي"),
          style: TextStyle(color: onSurfaceColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: onSurfaceColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Let Directionality handle it
          children: [
            const SizedBox(height: 30),

            // Account Security Title
            Text(
              t.tr(en: "Account Security", ar: "أمان الحساب"), 
              style: TextStyle(color: onSurfaceColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              t.tr(en: "Update your password regularly to keep your account safe.", ar: "قم بتحديث كلمة المرور الخاصة بك بانتظام للحفاظ على أمان حسابك."), 
              style: TextStyle(color: onSurfaceColor.withValues(alpha: 0.54), fontSize: 13),
            ),
            const SizedBox(height: 30),

            // Current Password
            _buildPasswordField(
              context,
              t.tr(en: "Current Password", ar: "كلمة المرور الحالية"), 
              "********", 
              _currentPasswordController,
              _obscureCurrent,
              () => setState(() => _obscureCurrent = !_obscureCurrent),
              isDark,
              onSurfaceColor,
            ),
            const SizedBox(height: 20),
            
            // New & Confirm Password
            Row(
              children: [
                Expanded(
                  child: _buildPasswordField(
                    context,
                    t.tr(en: "New Password", ar: "كلمة المرور الجديدة"), 
                    "********", 
                    _newPasswordController,
                    _obscureNew,
                    () => setState(() => _obscureNew = !_obscureNew),
                    isDark,
                    onSurfaceColor,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildPasswordField(
                    context,
                    t.tr(en: "Confirm Password", ar: "تأكيد كلمة المرور"), 
                    "********", 
                    _confirmPasswordController,
                    _obscureConfirm,
                    () => setState(() => _obscureConfirm = !_obscureConfirm),
                    isDark,
                    onSurfaceColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 60),
            Divider(color: onSurfaceColor.withValues(alpha: 0.12), height: 1),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: Align(
                alignment: isAr ? Alignment.centerLeft : Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF142C66),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(t.tr(en: "Save", ar: "حفظ"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive, VoidCallback onTap, bool isDark, Color onSurfaceColor) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isActive ? Theme.of(context).colorScheme.primary : onSurfaceColor.withValues(alpha: 0.5), 
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal, 
              fontSize: 14,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 2,
              width: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context, String label, String hint, TextEditingController controller, bool obscure, VoidCallback onToggle, bool isDark, Color onSurfaceColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Automatically Right in RTL
      children: [
        Text(label, style: TextStyle(color: onSurfaceColor, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(color: onSurfaceColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: onSurfaceColor.withValues(alpha: 0.3), fontSize: 13),
            suffixIcon: TextButton(
              onPressed: onToggle,
              child: Text(obscure ? "Show" : "Hide", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12)),
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF0D2D4D) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: onSurfaceColor.withValues(alpha: 0.12))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: onSurfaceColor.withValues(alpha: 0.12))),
          ),
        ),
      ],
    );
  }
}



