import 'package:flutter/material.dart';
import '../../../constants/app_images.dart';
import '../../../shared/l10n/app_localizations.dart';
import 'profile_login_details_screen.dart';
import 'setting_profile/notifications.dart';
import 'user_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _accountType = "Job Seeker";
  String _selectedGender = "Male";

  late TextEditingController _aboutMeController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _portfolioController;
  late TextEditingController _minSalaryController;
  late TextEditingController _maxSalaryController;
  late String _salaryFrequency;

  @override
  void initState() {
    super.initState();

    _aboutMeController = TextEditingController(text: "");
    _fullNameController = TextEditingController(text: "");
    _phoneController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _dobController = TextEditingController(text: "");
    _portfolioController = TextEditingController(text: UserProfileData.portfolioUrl);
    _minSalaryController = TextEditingController(
      text: UserProfileData.minSalary > 0 ? UserProfileData.minSalary.toInt().toString() : "",
    );
    _maxSalaryController = TextEditingController(
      text: UserProfileData.maxSalary > 0 ? UserProfileData.maxSalary.toInt().toString() : "",
    );
    _salaryFrequency = UserProfileData.salaryFrequency;
  }

  @override
  void dispose() {
    _aboutMeController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _portfolioController.dispose();
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    super.dispose();
  }

  void _saveData() {
    setState(() {
      UserProfileData.fullName = _fullNameController.text;
      UserProfileData.minSalary = double.tryParse(_minSalaryController.text.replaceAll(',', '')) ?? 0;
      UserProfileData.maxSalary = double.tryParse(_maxSalaryController.text.replaceAll(',', '')) ?? 0;
      UserProfileData.salaryFrequency = _salaryFrequency;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabItem(t.tr(en: "My Profile", ar: "ملفي الشخصي"), true, () {}),
                _buildTabItem(t.tr(en: "Login Details", ar: "تفاصيل الدخول"), false, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileLoginDetailsScreen()),
                  );
                }),
                _buildTabItem(t.notifications, false, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Notifications()),
                  );
                }),
              ],
            ),
            const SizedBox(height: 30),

            // Basic Information
            Text(t.tr(en: "Basic Information", ar: "معلومات أساسية"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(t.tr(en: "This is your personal information that you can update anytime.", ar: "هذه هي معلوماتك الشخصية التي يمكنك تحديثها في أي وقت."), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 13)),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            // Profile Photo
            Text(t.tr(en: "Profile Photo", ar: "صورة الملف الشخصي"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(t.tr(en: "This image will be shown publicly as your profile picture, it will help recruiters recognize you!", ar: "ستظهر هذه الصورة علنًا كصورة ملفك الشخصي، وسوف تساعد الموظفين على التعرف عليك!"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 12)),
            const SizedBox(height: 20),
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(AppImages.companyProfile1),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.image_outlined, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), size: 30),
                        const SizedBox(height: 8),
                        Text(t.tr(en: "Click to replace or drag and drop", ar: "انقر للاستبدال أو السحب والإفلات"), style: const TextStyle(color: Colors.blueAccent, fontSize: 12)),
                        Text(t.tr(en: "SVG, PNG, JPG or GIF (max. 400 x 400px)", ar: "SVG, PNG, JPG أو GIF (بحد أقصى 400 × 400 بكسل)"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            // About Me
            Text(t.aboutMe, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTextField(_aboutMeController, t.tr(en: "Enter About Me", ar: "أدخل معلومات عنك"), maxLines: 3),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            // Personal Details
            Text(t.tr(en: "Personal Details", ar: "تفاصيل شخصية"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildTextFieldWithLabel(_fullNameController, t.tr(en: "Full Name", ar: "الاسم بالكامل"), t.tr(en: "Enter Full Name", ar: "أدخل الاسم بالكامل"))),
                const SizedBox(width: 15),
                Expanded(child: _buildTextFieldWithLabel(_phoneController, t.tr(en: "Phone Number", ar: "رقم الهاتف"), t.tr(en: "Enter Phone Number", ar: "أدخل رقم الهاتف"))),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildTextFieldWithLabel(_emailController, t.tr(en: "Email", ar: "البريد الإلكتروني"), t.tr(en: "Enter Email", ar: "أدخل البريد الإلكتروني"))),
                const SizedBox(width: 15),
                Expanded(child: _buildTextFieldWithLabel(_dobController, t.dob, t.tr(en: "Enter Date of Birth", ar: "أدخل تاريخ الميلاد"), suffixIcon: Icons.calendar_today_outlined)),
              ],
            ),
            const SizedBox(height: 20),
            _buildDropdownField(t.gender, [t.male, t.female]),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            // Skills
            Text(t.tr(en: "Skills", ar: "المهارات"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildSkillTag("Facebook Ads"),
                _buildSkillTag("Content Planning"),
                _buildSkillTag("Analytics"),
                _buildSkillTag("Community Manager"),
              ],
            ),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            // Portfolio URL
            Text(t.tr(en: "Portfolio URL", ar: "رابط الأعمال"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTextField(_portfolioController, t.tr(en: "Link to your portfolio URL", ar: "رابط لمحفظتك")),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            // Salary Expectations
            Text(t.tr(en: "Salary Expectations", ar: "الراتب (بالجنيه)"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(t.tr(en: "Please specify your expected salary range.", ar: "يرجى تحديد الراتب المتوقع."), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 12)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(_minSalaryController, t.tr(en: "Min", ar: "الحد الأدنى"), keyboardType: TextInputType.number),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("-"),
                ),
                Expanded(
                  child: _buildTextField(_maxSalaryController, t.tr(en: "Max", ar: "الحد الأقصى"), keyboardType: TextInputType.number),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: "Monthly", label: Text(t.tr(en: "Monthly", ar: "شهرياً"))),
                ButtonSegment(value: "Yearly", label: Text(t.tr(en: "Yearly", ar: "سنوياً"))),
              ],
              selected: {_salaryFrequency},
              onSelectionChanged: (set) => setState(() => _salaryFrequency = set.first),
            ),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            // Account Type
            Text(t.tr(en: "Account Type", ar: "نوع الحساب"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(t.tr(en: "You can update your account type", ar: "يمكنك تحديث نوع حسابك"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 13)),
            const SizedBox(height: 20),
            _buildRadioOption(t.tr(en: "Job Seeker", ar: "باحث عن عمل"), t.tr(en: "Looking for a job", ar: "تبحث عن وظيفة")),
            _buildRadioOption(t.tr(en: "Workers", ar: "عمال"), t.tr(en: "Hiring, sourcing candidates, or posting a jobs", ar: "التوظيف ، البحث عن مرشحين ، أو نشر الوظائف")),
            
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(t.tr(en: "Save Profile", ar: "حفظ الملف الشخصي"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isActive ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), 
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

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark 
            ? Colors.white.withValues(alpha: 0.05) 
            : Colors.black.withValues(alpha: 0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.12))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.12))),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(TextEditingController controller, String label, String hint, {IconData? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
            children: const [TextSpan(text: " *", style: TextStyle(color: Colors.red))],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), size: 18) : null,
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white.withValues(alpha: 0.05) 
                : Colors.black.withValues(alpha: 0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.12))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.12))),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
            children: const [TextSpan(text: " *", style: TextStyle(color: Colors.red))],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white.withValues(alpha: 0.05) 
                : Colors.black.withValues(alpha: 0.05),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButton<String>(
            value: _selectedGender,
            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            underline: Container(),
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
            items: items.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)))).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedGender = newValue;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkillTag(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(skill, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 13)),
          const SizedBox(width: 8),
          Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), size: 14),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<String>(
            value: title,
            groupValue: _accountType,
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: (value) => setState(() => _accountType = value!),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

