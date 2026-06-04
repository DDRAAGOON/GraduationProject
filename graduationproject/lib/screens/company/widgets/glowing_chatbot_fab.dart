import 'package:flutter/material.dart';

class GlowingChatbotFAB extends StatefulWidget {
  final VoidCallback onTap;
  const GlowingChatbotFAB({super.key, required this.onTap});

  @override
  State<GlowingChatbotFAB> createState() => _GlowingChatbotFABState();
}

class _GlowingChatbotFABState extends State<GlowingChatbotFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5 * _controller.value),
                blurRadius: 20 * _controller.value,
                spreadRadius: 5 * _controller.value,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: widget.onTap,
            backgroundColor: color,
            elevation: 8,
            shape: const CircleBorder(), // Chat bubble shape (circular)
            child: const Icon(
              Icons.chat_bubble_outline, 
              color: Colors.white,
              size: 28,
            ),
          ),
        );
      },
    );
  }
}
