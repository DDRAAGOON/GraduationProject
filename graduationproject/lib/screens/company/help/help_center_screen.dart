import 'package:flutter/material.dart';

import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_title.dart';

class CompanyHelpCenterScreen extends StatelessWidget {
  const CompanyHelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Help Center',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search help',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(onPressed: () {}, child: const Text('Most relevant')),
            ],
          ),
          const SizedBox(height: 16),
          const SectionTitle('Popular articles'),
          const SizedBox(height: 10),
          const _FaqTile(
            title: 'What is My Applications?',
            body:
                'My Applications is a way for you to track jobs as you move through the application process...',
          ),
          const _FaqTile(
            title: 'How to access my applications history',
            body:
                'To access applications history, go to your My Applications page on your dashboard profile...',
          ),
          const _FaqTile(
            title: 'Not seeing jobs you applied in your my application list?',
            body:
                'Please note that we are unable to track materials submitted for jobs you apply to via an employer’s site...',
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Didn't find what you were looking for?",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Contact our customer service',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(onPressed: () {}, child: const Text('Contact Us')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.title, required this.body});
  final String title;
  final String body;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 10),
                Text(widget.body),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Was this article helpful?', style: Theme.of(context).textTheme.bodySmall),
                    const Spacer(),
                    OutlinedButton(onPressed: () {}, child: const Text('Yes')),
                    const SizedBox(width: 10),
                    OutlinedButton(onPressed: () {}, child: const Text('No')),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

