// Alternate chat layout for a candidate conversation.

import 'package:flutter/material.dart';

import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/models/message_thread.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../widgets/company_applicant_avatar.dart';

class CompanyChatThreadCandidateV2Screen extends StatefulWidget {
  const CompanyChatThreadCandidateV2Screen({super.key, required this.thread});

  final MessageThread thread;

  @override
  State<CompanyChatThreadCandidateV2Screen> createState() =>
      _CompanyChatThreadCandidateV2ScreenState();
}

class _CompanyChatThreadCandidateV2ScreenState
    extends State<CompanyChatThreadCandidateV2Screen> {
  final _input = TextEditingController();
  final List<_Bubble> _bubbles = [
    _Bubble(
      text:
          'Hey, I wanted to reach out because we saw your work contributions and were impressed by your work.',
      fromMe: true,
    ),
    _Bubble(text: 'We want to invite you for a quick interview', fromMe: true),
    _Bubble(
      text:
          'Hi Maria, sure I would love to. Thanks for taking the time to see my work!',
      fromMe: false,
    ),
  ];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _bubbles.add(_Bubble(text: text, fromMe: true));
      _input.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: widget.thread.title,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CompanyApplicantAvatar(seed: widget.thread.id, radius: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.thread.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.thread.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _bubbles.length,
              itemBuilder: (_, i) => _ChatBubble(bubble: _bubbles[i]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    decoration: InputDecoration(
                      hintText: t.replyMessage,
                      prefixIcon: const Icon(Icons.attach_file),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: _send,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _Bubble {
  const _Bubble({required this.text, required this.fromMe});

  final String text;
  final bool fromMe;
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.bubble});

  final _Bubble bubble;

  @override
  Widget build(BuildContext context) {
    final bg = bubble.fromMe
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.25)
        : Colors.white.withValues(alpha: 0.10);
    final align = bubble.fromMe ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart;
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.72;

    return Align(
      alignment: align,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxBubbleWidth.clamp(220.0, 360.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(bubble.text),
      ),
    );
  }
}
