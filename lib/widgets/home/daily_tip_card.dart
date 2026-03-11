// ─────────────────────────────────────────────────────────────────────────────
//  widgets/home/daily_tip_card.dart
//  Expandable agricultural knowledge / daily tip card
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/home_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/tip_model.dart';

class DailyTipCard extends StatefulWidget {
  const DailyTipCard({super.key});

  @override
  State<DailyTipCard> createState() => _DailyTipCardState();
}

class _DailyTipCardState extends State<DailyTipCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        final tip = controller.dailyTip;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _TipCardContainer(
            tip: tip,
            isExpanded: _isExpanded,
            expandAnimation: _expandAnimation,
            rotateAnimation: _rotateAnimation,
            onToggle: _toggleExpanded,
            onNextTip: () {
              controller.nextTip();
              if (_isExpanded) {
                setState(() {
                  _isExpanded = false;
                  _animController.reverse();
                });
              }
            },
          ),
        );
      },
    );
  }
}

// ─── Internal Card Container ──────────────────────────────────────────────────

class _TipCardContainer extends StatelessWidget {
  const _TipCardContainer({
    required this.tip,
    required this.isExpanded,
    required this.expandAnimation,
    required this.rotateAnimation,
    required this.onToggle,
    required this.onNextTip,
  });

  final TipModel tip;
  final bool isExpanded;
  final Animation<double> expandAnimation;
  final Animation<double> rotateAnimation;
  final VoidCallback onToggle;
  final VoidCallback onNextTip;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F5E9),
            Color(0xFFF1F8E9),
            Color(0xFFDCEDC8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryLight.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColors.primary.withOpacity(0.08),
          highlightColor: AppColors.primary.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header row ──────────────────────────────────────
                _buildHeader(),

                // ── Title ───────────────────────────────────────────
                const SizedBox(height: 10),
                _buildTitle(),

                // ── Expandable content ──────────────────────────────
                SizeTransition(
                  sizeFactor: expandAnimation,
                  axisAlignment: -1.0,
                  child: _buildExpandedContent(),
                ),

                // ── Footer ──────────────────────────────────────────
                const SizedBox(height: 12),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header row: badge + rotate icon ────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tip.icon,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 4),
              Text(
                'เคล็ดลับวันนี้',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.tipGreenDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Category chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            tip.category,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Expand / Collapse arrow
        RotationTransition(
          turns: rotateAnimation,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  // ── Tip title (always visible) ──────────────────────────────────────────────
  Widget _buildTitle() {
    return Text(
      tip.title,
      style: AppTextStyles.tipTitle,
      maxLines: isExpanded ? null : 2,
      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
    );
  }

  // ── Expanded full content ───────────────────────────────────────────────────
  Widget _buildExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // Divider
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.primary.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Full tip content
        Text(
          tip.content,
          style: AppTextStyles.tipBody,
        ),

        // Related product link
        if (tip.relatedProductName != null) ...[
          const SizedBox(height: 14),
          _RelatedProductChip(productName: tip.relatedProductName!),
        ],

        const SizedBox(height: 4),
      ],
    );
  }

  // ── Footer: "ดูทั้งหมด" + next tip button ──────────────────────────────────
  Widget _buildFooter() {
    return Row(
      children: [
        // Read more / collapse indicator
        Text(
          isExpanded ? 'แตะเพื่อย่อ' : 'แตะเพื่ออ่านเพิ่มเติม',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primary.withOpacity(0.7),
            fontStyle: FontStyle.italic,
          ),
        ),

        const Spacer(),

        // Next tip button
        GestureDetector(
          onTap: onNextTip,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'เคล็ดลับถัดไป',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 13,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Related Product Chip ─────────────────────────────────────────────────────

class _RelatedProductChip extends StatelessWidget {
  const _RelatedProductChip({required this.productName});

  final String productName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.link_rounded,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'สินค้าที่เกี่ยวข้อง: $productName',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.chevron_right_rounded,
            size: 14,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

// ─── Standalone tip card (used in Knowledge Hub screen) ──────────────────────

class TipListCard extends StatelessWidget {
  const TipListCard({
    super.key,
    required this.tip,
    this.onTap,
  });

  final TipModel tip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.divider,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon bubble
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                tip.icon,
                style: const TextStyle(fontSize: 22),
              ),
            ),

            const SizedBox(width: 12),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tip.category,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Title
                  Text(
                    tip.title,
                    style: AppTextStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Preview of content
                  Text(
                    tip.content,
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Related product
                  if (tip.relatedProductName != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 12,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tip.relatedProductName!,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
