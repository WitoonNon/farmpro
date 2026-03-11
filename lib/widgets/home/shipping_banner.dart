// ─────────────────────────────────────────────────────────────────────────────
//  widgets/home/shipping_banner.dart
//  Animated orange gradient banner showing free-shipping threshold progress
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class ShippingBanner extends StatelessWidget {
  const ShippingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cart, _) {
        final hasFreeShipping = cart.hasFreeShipping;
        final remaining = cart.amountForFreeShipping;
        final progress = (cart.subtotal / 8500.0).clamp(0.0, 1.0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _BannerCard(
            hasFreeShipping: hasFreeShipping,
            remaining: remaining,
            progress: progress,
          ),
        );
      },
    );
  }
}

// ─── Internal card widget ─────────────────────────────────────────────────────

class _BannerCard extends StatelessWidget {
  final bool hasFreeShipping;
  final double remaining;
  final double progress;

  const _BannerCard({
    required this.hasFreeShipping,
    required this.remaining,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.shippingOrange,
            AppColors.shippingOrangeLight,
            Color(0xFFFF8F00),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.shippingOrange.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            // Navigate to cart or product list
          },
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: hasFreeShipping
                ? _FreeShippingContent()
                : _ProgressContent(
                    remaining: remaining,
                    progress: progress,
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── State: already qualifies for free shipping ───────────────────────────────

class _FreeShippingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Truck icon with glow
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text('🚚', style: TextStyle(fontSize: 24)),
          ),
        ),

        const SizedBox(width: 14),

        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ยินดีด้วย! คุณได้รับสิทธิ์ส่งฟรี 🎉',
                style: AppTextStyles.shippingTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                'คำสั่งซื้อของคุณจะได้รับการจัดส่งฟรีทั่วประเทศ',
                style: AppTextStyles.shippingSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Full progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 1.0,
                  minHeight: 6,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Check badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '✓ ฟรี',
            style: AppTextStyles.shippingTitle.copyWith(
              color: AppColors.shippingOrange,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── State: progress toward free shipping ────────────────────────────────────

class _ProgressContent extends StatelessWidget {
  final double remaining;
  final double progress;

  const _ProgressContent({
    required this.remaining,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Truck icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text('🚛', style: TextStyle(fontSize: 24)),
          ),
        ),

        const SizedBox(width: 14),

        // Text + progress
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ส่งฟรีทั่วประเทศ!',
                style: AppTextStyles.shippingTitle,
              ),
              const SizedBox(height: 2),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.shippingSubtitle,
                  children: [
                    const TextSpan(text: 'สั่งซื้อเพิ่มอีก '),
                    TextSpan(
                      text:
                          '฿${remaining.toStringAsFixed(0)}',
                      style: AppTextStyles.shippingSubtitle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ' รับของถึงหน้าไร่'),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Progress bar
              Stack(
                children: [
                  // Track
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Fill
                  AnimatedFractionallySizedBox(
                    widthFactor: progress,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.6),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Chevron arrow
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }
}
