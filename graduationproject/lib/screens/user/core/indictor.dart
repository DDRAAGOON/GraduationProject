import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final bool isActive;

  const Indicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 6),
      width: isActive ? 32 : 12,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFF0A335E),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
