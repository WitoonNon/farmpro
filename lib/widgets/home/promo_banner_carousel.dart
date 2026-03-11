// ─────────────────────────────────────────────────────────────────────────────
//  widgets/home/promo_banner_carousel.dart
//  Auto-playing promotional banner carousel with smooth page indicators
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controllers/home_controller.dart';
import '../../models/promo_banner_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class PromoBannerCarousel extends StatefulWidget {
  const PromoBannerCarousel({super.key});

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  late final PageController _pageController;
  Timer? _autoPlayTimer;

  static const Duration _autoPlayInterval = Duration(seconds: 4);
  static const Duration _animationDuration = Duration(milliseconds: 500);
  static const Curve _animationCurve = Curves.easeInOutCubic;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(_autoPlayInterval, (_) {
      if (!mounted || !_pageController.hasClients) return;

      final controller = context.read<HomeController>();
      final bannersLength = controller.banners.length;
      if (bannersLength <= 1) return;

      final nextIndex = (controller.currentBannerIndex + 1) % bannersLength;

      _pageController.animateToPage(
        nextIndex,
        duration: _animationDuration,
        curve: _animationCurve,
      );
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        final banners = controller.banners;

        if (banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Banner Pager ──────────────────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 160,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: banners.length,
                    onPageChanged: controller.setBannerIndex,
                    itemBuilder: (context, index) {
                      return _BannerCard(
                        banner: banners[index],
                        index: index,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── Page Indicator ───────────────────────────────────────────
              AnimatedSmoothIndicator(
                activeIndex: controller.currentBannerIndex,
                count: banners.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotColor: AppColors.primary,
                  dotColor: AppColors.divider,
                  expansionFactor: 3.5,
                  spacing: 5,
                  strokeWidth: 0,
                ),
                onDotClicked: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: _animationDuration,
                    curve: _animationCurve,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Single Banner Card ───────────────────────────────────────────────────────

class _BannerCard extends StatelessWidget {
  final PromoBannerModel banner;
  final int index;

  const _BannerCard({required this.banner, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('โปรโมชัน: ${banner.title}'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [banner.backgroundColor, banner.gradientEndColor],
              stops: const [0.0, 1.0],
            ),
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // ── Decorative circles ──────────────────────────────────────
              Positioned(
                right: -20,
                top: -30,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              Positioned(
                right: 30,
                bottom: -40,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                left: -15,
                bottom: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),

              // ── Content ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left: Text
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _BadgePill(text: banner.badgeText),
                          const SizedBox(height: 5),
                          Text(
                            banner.title,
                            style: AppTextStyles.bannerTitle
                                .copyWith(fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            banner.subtitle,
                            style: AppTextStyles.bannerSubtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  banner.discountText,
                                  style: AppTextStyles.bannerDiscount
                                      .copyWith(
                                    fontSize: 26,
                                    height: 1.1,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    banner.discountLabel,
                                    style: AppTextStyles.bannerSubtitle
                                        .copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Right: Emoji illustration
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: _EmojiIllustration(emoji: banner.emoji),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Badge Pill ───────────────────────────────────────────────────────────────

class _BadgePill extends StatelessWidget {
  final String text;

  const _BadgePill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.bannerBadge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ─── Emoji Illustration ───────────────────────────────────────────────────────

class _EmojiIllustration extends StatelessWidget {
  final String emoji;

  const _EmojiIllustration({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 38),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
