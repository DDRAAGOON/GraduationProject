import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';

class ProfileLoginDetailsScreen extends StatefulWidget {
  const ProfileLoginDetailsScreen({super.key});

  @override
  State<ProfileLoginDetailsScreen> createState() =>
      _ProfileLoginDetailsScreenState();
}

class _ProfileLoginDetailsScreenState extends State<ProfileLoginDetailsScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isDeletionRequested = false;

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
      _showError(
        t.tr(en: "Please fill all fields", ar: "يرجى ملء جميع الحقول"),
      );
      return;
    }

    if (newPass.length < 8) {
      _showError(
        t.tr(
          en: "New password must be at least 8 characters",
          ar: "يجب أن تكون كلمة المرور الجديدة 8 أحرف على الأقل",
        ),
      );
      return;
    }

    if (newPass != confirm) {
      _showError(
        t.tr(en: "Passwords do not match", ar: "كلمات المرور غير متطابقة"),
      );
      return;
    }

    // Success simulation for the project
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.tr(
            en: "Password Updated Successfully!",
            ar: "تم تحديث كلمة المرور بنجاح!",
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );

    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  void _showDeleteConfirmation() {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isAr ? "حذف الحساب" : "Delete Account",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          isAr
              ? "هل أنت متأكد من رغبتك في حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء."
              : "Are you sure you want to delete your account? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processDeletionRequest();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              isAr ? "نعم، حذف" : "Yes, Delete",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _processDeletionRequest() {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;

    setState(() => _isDeletionRequested = true);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.info_outline, color: Colors.orange, size: 48),
        content: Text(
          isAr
              ? "تم استلام طلبك. سوف يتم حذف حسابك نهائياً خلال 10 أيام. يمكنك إلغاء الطلب في أي وقت قبل ذلك."
              : "Request received. Your account will be permanently deleted within 10 days. You can cancel the request at any time before that.",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF142C66),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isAr ? "حسناً" : "OK",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _cancelDeletionRequest() {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;

    setState(() => _isDeletionRequested = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAr
              ? "تم إلغاء طلب حذف الحساب بنجاح"
              : "Account deletion request cancelled successfully",
        ),
        backgroundColor: Colors.green,
      ),
    );
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
    final backgroundColor = isDark
        ? const Color(0xFF001E3A)
        : const Color(0xFFF8FBF4);
    final onSurfaceColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          t.tr(en: "Edit Profile", ar: "تعديل الملف الشخصي"),
          style: TextStyle(
            color: onSurfaceColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
          crossAxisAlignment:
              CrossAxisAlignment.start, // Let Directionality handle it
          children: [
            const SizedBox(height: 30),

            // Account Security Title
            Text(
              t.tr(en: "Account Security", ar: "أمان الحساب"),
              style: TextStyle(
                color: onSurfaceColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.tr(
                en: "Update your password regularly to keep your account safe.",
                ar: "قم بتحديث كلمة المرور الخاصة بك بانتظام للحفاظ على أمان حسابك.",
              ),
              style: TextStyle(
                color: onSurfaceColor.withValues(alpha: 0.54),
                fontSize: 13,
              ),
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

            // Save & Delete Buttons
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: isAr
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  if (_isDeletionRequested)
                    ElevatedButton(
                      onPressed: _cancelDeletionRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        isAr ? "إلغاء طلب الحذف" : "Cancel Deletion",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: _showDeleteConfirmation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        isAr ? "حذف الحساب" : "Delete Account",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF142C66),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      t.tr(en: "Save", ar: "حفظ"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    String label,
    String hint,
    TextEditingController controller,
    bool obscure,
    VoidCallback onToggle,
    bool isDark,
    Color onSurfaceColor,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Automatically Right in RTL
      children: [
        Text(
          label,
          style: TextStyle(
            color: onSurfaceColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(color: onSurfaceColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: onSurfaceColor.withValues(alpha: 0.3),
              fontSize: 13,
            ),
            suffixIcon: TextButton(
              onPressed: onToggle,
              child: Text(
                obscure ? "Show" : "Hide",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                ),
              ),
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF0D2D4D) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: onSurfaceColor.withValues(alpha: 0.12),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: onSurfaceColor.withValues(alpha: 0.12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
