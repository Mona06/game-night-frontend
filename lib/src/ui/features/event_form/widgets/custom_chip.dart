import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final VoidCallback? onDelete;
  final Color backgroundColor;
  final Color textColor;
  final Color outlineColor;
  final IconData? prefixIcon;

  const CustomChip({
    super.key,
    required this.label,
    this.onDelete,
    required this.backgroundColor,
    required this.textColor,
    required this.outlineColor,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: outlineColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixIcon != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(
                prefixIcon,
                size: 16,
                color: textColor,
              ),
            ),
          ],
          Padding(
            padding: EdgeInsets.only(
              left: prefixIcon != null ? 4 : 8,
              right: onDelete != null ? 4 : 8,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              ),
            ),
          ),
          if (onDelete != null)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: textColor.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Primary Badge/Chip
class PrimaryBadge extends StatelessWidget {
  final String label;
  final VoidCallback? onDelete;
  final IconData? prefixIcon;

  const PrimaryBadge({
    super.key,
    required this.label,
    this.onDelete,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomChip(
      label: label,
      onDelete: onDelete,
      prefixIcon: prefixIcon,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
      outlineColor: Theme.of(context).colorScheme.outline,
    );
  }
}

// Secondary Badge/Chip
class SecondaryBadge extends StatelessWidget {
  final String label;
  final VoidCallback? onDelete;
  final IconData? prefixIcon;

  const SecondaryBadge({
    super.key,
    required this.label,
    this.onDelete,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomChip(
      label: label,
      onDelete: onDelete,
      prefixIcon: prefixIcon,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.onSecondary,
      outlineColor: Theme.of(context).colorScheme.outline,
    );
  }
}

// Tertiary Badge/Chip
class TertiaryBadge extends StatelessWidget {
  final String label;
  final VoidCallback? onDelete;
  final IconData? prefixIcon;

  const TertiaryBadge({
    super.key,
    required this.label,
    this.onDelete,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomChip(
      label: label,
      onDelete: onDelete,
      prefixIcon: prefixIcon,
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      textColor: Theme.of(context).colorScheme.onTertiaryContainer,
      outlineColor: Theme.of(context).colorScheme.tertiary,
    );
  }
}

// Surface Variant Badge/Chip
class SurfaceVariantBadge extends StatelessWidget {
  final String label;
  final VoidCallback? onDelete;
  final IconData? prefixIcon;

  const SurfaceVariantBadge({
    super.key,
    required this.label,
    this.onDelete,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomChip(
      label: label,
      onDelete: onDelete,
      prefixIcon: prefixIcon,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      textColor: Theme.of(context).colorScheme.onSurfaceVariant,
      outlineColor: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

// Background Badge/Chip
class BackgroundBadge extends StatelessWidget {
  final String label;
  final VoidCallback? onDelete;
  final IconData? prefixIcon;

  const BackgroundBadge({
    super.key,
    required this.label,
    this.onDelete,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomChip(
      label: label,
      onDelete: onDelete,
      prefixIcon: prefixIcon,
      backgroundColor: const Color(0xfffdf7ff),
      textColor: const Color(0xff1d1b20),
      outlineColor: const Color(0xff7a757f),
    );
  }
}
