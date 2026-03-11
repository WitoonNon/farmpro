import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// A reusable section header row used throughout the home screen.
///
/// Displays a [title] on the left, and an optional "ทั้งหมด →" link on the right.
///
/// Example:
/// ```dart
/// SectionHeader(
///   title: 'สินค้าขายดี 🔥',
///   onSeeAll: () => Navigator.push(context, ...),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.seeAllLabel = 'ทั้งหมด',
    this.onSeeAll,
    this.titleStyle,
    this.padding,
    this.showDivider = false,
  });

  /// Main section title — e.g. "สินค้าขายดี 🔥"
  final String title;

  /// Optional smaller subtitle rendered below the title.
  final String? subtitle;

  /// Label for the "see all" button. Defaults to "ทั้งหมด".
  final String seeAllLabel;

  /// Called when the "see all" button is tapped.
  /// If null the button is hidden entirely.
  final VoidCallback? onSeeAll;

  /// Override the title [TextStyle] if needed.
  final TextStyle? titleStyle;

  /// Outer padding. Defaults to `EdgeInsets.symmetric(horizontal: 16, vertical: 4)`.
  final EdgeInsetsGeometry? padding;

  /// Draw a thin divider below the header when true.
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Left: title + optional subtitle ──────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: titleStyle ?? AppTextStyles.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // ── Right: "see all" button ───────────────────────────────────
              if (onSeeAll != null) ...[
                const SizedBox(width: 8),
                _SeeAllButton(
                  label: seeAllLabel,
                  onTap: onSeeAll!,
                ),
              ],
            ],
          ),
        ),

        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.divider,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}

// ─── Private "See All" button ─────────────────────────────────────────────────

class _SeeAllButton extends StatelessWidget {
  const _SeeAllButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        // Extra tap-target padding so farmers with gloves can still tap it.
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTextStyles.seeAllLink),
            const SizedBox(width: 2),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 11,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
