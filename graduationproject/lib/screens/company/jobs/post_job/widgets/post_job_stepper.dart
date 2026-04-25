import 'package:flutter/material.dart';
import '../../../../../shared/l10n/app_localizations.dart';

class PostJobStepper extends StatelessWidget {
  final int currentStep;
  const PostJobStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          _buildStep(
            context,
            isActive: currentStep >= 1,
            isCompleted: currentStep > 1,
          ),
          _buildDivider(context, isActive: currentStep > 1),
          _buildStep(
            context,
            isActive: currentStep >= 2,
            isCompleted: currentStep > 2,
          ),
          _buildDivider(context, isActive: currentStep > 2),
          _buildStep(
            context,
            isActive: currentStep >= 3,
            isCompleted: currentStep > 3,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required bool isActive,
    required bool isCompleted,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;

    return Expanded(
      child: Center(
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isCompleted ? primary : (isActive ? primary.withValues(alpha: 0.1) : colorScheme.surface),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted || isActive ? primary : colorScheme.outline.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isActive ? primary : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context, {required bool isActive}) {
    return Container(
      width: 30,
      height: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive 
          ? Theme.of(context).colorScheme.primary 
          : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
