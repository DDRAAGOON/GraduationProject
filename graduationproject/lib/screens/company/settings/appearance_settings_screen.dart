import 'package:flutter/material.dart';

import '../../../shared/state/theme_controller.dart';
import '../../../shared/widgets/app_scaffold.dart';

class CompanyAppearanceSettingsScreen extends StatefulWidget {
  const CompanyAppearanceSettingsScreen({
    super.key,
    required this.initialTheme,
  });

  final String initialTheme;

  @override
  State<CompanyAppearanceSettingsScreen> createState() =>
      _CompanyAppearanceSettingsScreenState();
}

class _CompanyAppearanceSettingsScreenState
    extends State<CompanyAppearanceSettingsScreen> {
  late String _theme = widget.initialTheme;
  String _lang = 'English';

  @override
  void initState() {
    super.initState();
    _theme = ThemeController.instance.themeMode.value == ThemeMode.light
        ? 'Light'
        : 'Dark';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Appearance',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Dark', label: Text('Dark')),
                ButtonSegment(value: 'Light', label: Text('Light')),
              ],
              selected: {_theme},
              onSelectionChanged: (s) {
                final selected = s.first;
                setState(() => _theme = selected);
                if (selected == 'Light') {
                  ThemeController.instance.setLight();
                } else {
                  ThemeController.instance.setDark();
                }
              },
            ),
            const SizedBox(height: 20),
            Text('Language', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'English', label: Text('English')),
                ButtonSegment(value: 'العربية', label: Text('العربية')),
              ],
              selected: {_lang},
              onSelectionChanged: (s) => setState(() => _lang = s.first),
            ),
            const Spacer(),
            Text(
              'Default theme is Dark. Light applies only when selected here.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
