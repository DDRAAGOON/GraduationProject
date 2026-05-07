// Theme and language appearance settings.

import 'package:flutter/material.dart';

import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/locale_controller.dart';
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
  late String _lang;

  @override
  void initState() {
    super.initState();
    _theme = ThemeController.instance.themeMode.value == ThemeMode.light
        ? 'Light'
        : 'Dark';
    _lang = LocaleController.instance.locale.value.languageCode == 'ar'
        ? 'العربية'
        : 'English';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: t.tr(en: 'Appearance', ar: 'المظهر'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.tr(en: 'Theme', ar: 'المظهر العام'),
                style: Theme.of(context).textTheme.titleSmall),
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
            Text(t.tr(en: 'Language', ar: 'اللغة'),
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'English', label: Text('English')),
                ButtonSegment(value: 'العربية', label: Text('العربية')),
              ],
              selected: {_lang},
              onSelectionChanged: (s) {
                final selected = s.first;
                setState(() => _lang = selected);
                if (selected == 'العربية') {
                  LocaleController.instance.locale.value = const Locale('ar');
                } else {
                  LocaleController.instance.locale.value = const Locale('en');
                }
              },
            ),
            const Spacer(),
            Text(
              t.tr(
                en: 'Default theme is Dark. Light applies only when selected here.',
                ar: 'المظهر الافتراضي هو الداكن. المظهر الفاتح يتم تطبيقه فقط عند اختياره من هنا.',
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
