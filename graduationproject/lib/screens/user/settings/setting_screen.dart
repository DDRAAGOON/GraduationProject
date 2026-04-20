import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _selectedLanguage = "Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©";
  String _selectedTheme = "Ø§Ù„Ù†Ø¸Ø§Ù…";
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
        automaticallyImplyLeading: false, // Ù„Ù…Ù†Ø¹ Ø¸Ù‡ÙˆØ± Ø§Ù„Ø³Ù‡Ù… Ø§Ù„ØªÙ„Ù‚Ø§Ø¦ÙŠ Ø¬Ù‡Ø© Ø§Ù„ÙŠØ³Ø§Ø±
        title: const Text(
          "Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª",
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
                "Ø§Ù„ØªÙØ¶ÙŠÙ„Ø§Øª",
                style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Language Section
              _buildSectionCard(
                title: "Ø§Ù„Ù„ØºØ©",
                subtitle: _selectedLanguage,
                icon: Icons.language,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isLanguageExpanded = !_isLanguageExpanded),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
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
                                    const Text("Ø§Ù„Ù„ØºØ©", style: TextStyle(color: Colors.white38, fontSize: 12)),
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
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          children: [
                            _buildOptionItem("Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©", Icons.language, _selectedLanguage == "Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©", (val) {
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
                title: "Ø§Ù„Ù…Ø¸Ù‡Ø±",
                subtitle: _selectedTheme,
                icon: Icons.palette_outlined,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isThemeExpanded = !_isThemeExpanded),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
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
                                    const Text("Ø§Ù„Ù…Ø¸Ù‡Ø±", style: TextStyle(color: Colors.white38, fontSize: 12)),
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
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          children: [
                            _buildOptionItem("ÙØ§ØªØ­", Icons.wb_sunny_outlined, _selectedTheme == "ÙØ§ØªØ­", (val) {
                              setState(() => _selectedTheme = val);
                            }),
                            const Divider(color: Colors.white10, height: 1),
                            _buildOptionItem("Ø¯Ø§ÙƒÙ†", Icons.nightlight_round_outlined, _selectedTheme == "Ø¯Ø§ÙƒÙ†", (val) {
                              setState(() => _selectedTheme = val);
                            }),
                            const Divider(color: Colors.white10, height: 1),
                            _buildOptionItem("Ø§Ù„Ù†Ø¸Ø§Ù…", Icons.settings_brightness_outlined, _selectedTheme == "Ø§Ù„Ù†Ø¸Ø§Ù…", (val) {
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
              decoration: BoxDecoration(color: const Color(0xFF094174).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(12)),
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
          color: isSelected ? const Color(0xFF49769F).withValues(alpha: 0.2) : Colors.transparent,
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

