import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _selectedLanguage = "العربية";
  String _selectedTheme = "النظام";
  bool _isLanguageExpanded = false;
  bool _isThemeExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // لمنع ظهور السهم التلقائي جهة اليسار
        title: const Text(
          "الإعدادات",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "التفضيلات",
                style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Language Section
              _buildSectionCard(
                title: "اللغة",
                subtitle: _selectedLanguage,
                icon: Icons.language,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isLanguageExpanded = !_isLanguageExpanded),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: _isLanguageExpanded ? const Color(0xFF49769F) : Colors.white12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(_isLanguageExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white54),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text("اللغة", style: TextStyle(color: Colors.white38, fontSize: 12)),
                                    Text(_selectedLanguage, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.public, color: Colors.white70),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isLanguageExpanded) ...[
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          children: [
                            _buildOptionItem("العربية", Icons.language, _selectedLanguage == "العربية", (val) {
                              setState(() {
                                _selectedLanguage = val;
                                _isLanguageExpanded = false;
                              });
                            }),
                            const Divider(color: Colors.white10, height: 1),
                            _buildOptionItem("English", Icons.language, _selectedLanguage == "English", (val) {
                              setState(() {
                                _selectedLanguage = val;
                                _isLanguageExpanded = false;
                              });
                            }),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Theme Section
              _buildSectionCard(
                title: "المظهر",
                subtitle: _selectedTheme,
                icon: Icons.palette_outlined,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isThemeExpanded = !_isThemeExpanded),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: _isThemeExpanded ? const Color(0xFF49769F) : Colors.white12, width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(_isThemeExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white54),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text("المظهر", style: TextStyle(color: Colors.white38, fontSize: 12)),
                                    Text(_selectedTheme, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.palette, color: Colors.white70),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isThemeExpanded) ...[
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          children: [
                            _buildOptionItem("فاتح", Icons.wb_sunny_outlined, _selectedTheme == "فاتح", (val) {
                              setState(() => _selectedTheme = val);
                            }),
                            const Divider(color: Colors.white10, height: 1),
                            _buildOptionItem("داكن", Icons.nightlight_round_outlined, _selectedTheme == "داكن", (val) {
                              setState(() => _selectedTheme = val);
                            }),
                            const Divider(color: Colors.white10, height: 1),
                            _buildOptionItem("النظام", Icons.settings_brightness_outlined, _selectedTheme == "النظام", (val) {
                              setState(() => _selectedTheme = val);
                            }),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required String subtitle, required IconData icon, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF094174).withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: const Color(0xFF49769F), size: 22),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildOptionItem(String label, IconData icon, bool isSelected, Function(String) onTap) {
    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF49769F).withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isSelected) const Icon(Icons.check, color: Color(0xFF49769F), size: 20) else const SizedBox(width: 20),
            Row(
              children: [
                Text(label, style: TextStyle(color: isSelected ? const Color(0xFF49769F) : Colors.white70, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                const SizedBox(width: 12),
                Icon(icon, color: isSelected ? const Color(0xFF49769F) : Colors.white38, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
