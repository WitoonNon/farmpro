// =============================================================================
//  views/home/home_view.dart
//  FarmPro – Smart Agriculture Store
//  Main entry screen: header · carousel · categories · tips · best sellers
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/home_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/product_model.dart';
import '../../widgets/common/farm_search_bar.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/home/category_section.dart';
import '../../widgets/home/daily_tip_card.dart';
import '../../widgets/home/promo_banner_carousel.dart';
import '../../widgets/home/shipping_banner.dart';
import '../../views/cart/cart_view.dart';
import '../../widgets/product/product_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  // ── Bottom nav index ─────────────────────────────────────────────────────────
  int _selectedNavIndex = 0;

  // ── Scroll controller for collapsing header ──────────────────────────────────
  late final ScrollController _scrollController;
  bool _isHeaderCollapsed = false;

  // ── Tab animation ─────────────────────────────────────────────────────────────
  late final AnimationController _navAnimController;

  // ── Nav destinations ─────────────────────────────────────────────────────────
  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_rounded,        outlineIcon: Icons.home_outlined,        label: 'หน้าหลัก'),
    _NavItem(icon: Icons.search_rounded,      outlineIcon: Icons.search_outlined,      label: 'ค้นหา'),
    _NavItem(icon: Icons.shopping_cart_rounded, outlineIcon: Icons.shopping_cart_outlined, label: 'ตะกร้า'),
    _NavItem(icon: Icons.receipt_long_rounded, outlineIcon: Icons.receipt_long_outlined, label: 'คำสั่งซื้อ'),
    _NavItem(icon: Icons.person_rounded,      outlineIcon: Icons.person_outline_rounded, label: 'โปรไฟล์'),
  ];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);

    _navAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Kick off any initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().refresh();
    });
  }

  void _onScroll() {
    final collapsed = _scrollController.offset > 20;
    if (collapsed != _isHeaderCollapsed) {
      setState(() => _isHeaderCollapsed = collapsed);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _navAnimController.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
      // Floating cart FAB appears only on home tab when cart has items
      floatingActionButton:
          _selectedNavIndex == 0 ? _buildCartFab() : null,
    );
  }

  // ── Body Router ──────────────────────────────────────────────────────────────

  Widget _buildBody() {
    switch (_selectedNavIndex) {
      case 0:
        return _buildHomeBody();
      case 2:
        return const CartView();
      default:
        return _buildStubScreen(_selectedNavIndex);
    }
  }

  // ── Home Body ─────────────────────────────────────────────────────────────────

  Widget _buildHomeBody() {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        return RefreshIndicator(
          onRefresh: controller.refresh,
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // ── Sticky header ────────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildHeader(controller)),

              // ── Body content ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Promo carousel
                    const PromoBannerCarousel(),

                    const SizedBox(height: 24),

                    // Category grid
                    const CategorySection(),

                    const SizedBox(height: 20),

                    // Free shipping banner
                    const ShippingBanner(),

                    const SizedBox(height: 20),

                    // Daily tip
                    _buildDailyTipSection(),

                    const SizedBox(height: 24),

                    // Best sellers
                    _buildBestSellersSection(controller),

                    const SizedBox(height: 24),

                    // On-sale products
                    _buildOnSaleSection(controller),

                    // Bottom padding so FAB/nav doesn't overlap content
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────────

  Widget _buildHeader(HomeController controller) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.headerDark,
            AppColors.headerMid,
            Color(0xFF1F4E35),
          ],
          stops: [0.0, 0.65, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Row 1: Greeting + Notification ────────────────────────────
              _buildGreetingRow(controller),

              const SizedBox(height: 14),

              // ── Row 2: Brand logo row ─────────────────────────────────────
              _buildBrandRow(),

              const SizedBox(height: 14),

              // ── Row 3: Search bar ─────────────────────────────────────────
              StaticSearchBar(
                hintText: 'ค้นหาปุ๋ย อุปกรณ์ สารกำจัดศัตรูพืช...',
                onTap: () {
                  setState(() => _selectedNavIndex = 1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingRow(HomeController controller) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent.withOpacity(0.9),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: const Center(
            child: Text('👨‍🌾', style: TextStyle(fontSize: 18)),
          ),
        ),

        const SizedBox(width: 10),

        // Greeting text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.greetingText,
                style: AppTextStyles.greetingText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                controller.userName,
                style: AppTextStyles.usernameText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const Spacer(),

        // Notification bell
        _buildNotificationBell(controller),
      ],
    );
  }

  Widget _buildNotificationBell(HomeController controller) {
    return GestureDetector(
      onTap: () {
        controller.clearNotifications();
        _showNotificationSheet();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),

          // Badge
          if (controller.notificationCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: AppColors.badge,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    controller.notificationCount > 9
                        ? '9+'
                        : '${controller.notificationCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBrandRow() {
    return Row(
      children: [
        // App icon
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text('🌾', style: TextStyle(fontSize: 24)),
          ),
        ),

        const SizedBox(width: 12),

        // Brand name + tagline
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'FarmPro',
                      style: AppTextStyles.brandName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '✦',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'ปุ๋ยคุณภาพ ส่งถึงไร่',
                style: AppTextStyles.greetingText.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Daily Tip Section ─────────────────────────────────────────────────────────

  Widget _buildDailyTipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: '📚 ความรู้เกษตร',
          subtitle: 'เคล็ดลับจากผู้เชี่ยวชาญ',
          onSeeAll: () {
            _showKnowledgeHubSheet();
          },
        ),
        const SizedBox(height: 12),
        const DailyTipCard(),
      ],
    );
  }

  // ── Best Sellers Section ──────────────────────────────────────────────────────

  Widget _buildBestSellersSection(HomeController controller) {
    final products = controller.bestSellers;

    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'สินค้าขายดี 🔥',
          subtitle: 'ยอดนิยมในหมู่เกษตรกร',
          onSeeAll: () {},
        ),
        const SizedBox(height: 14),

        // Horizontal scroll list
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 150,
                  child: ProductCard(
                    product: product,
                    compact: true,
                    isWishlisted:
                        controller.isWishlisted(product.id),
                    onWishlistToggle: () =>
                        controller.toggleWishlist(product.id),
                    onTap: () => _showProductDetail(product),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── On-Sale Section ───────────────────────────────────────────────────────────

  Widget _buildOnSaleSection(HomeController controller) {
    final products = controller.onSaleProducts;

    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: '🏷️ โปรโมชันลดราคา',
          subtitle: 'จำนวนจำกัด รีบซื้อก่อนหมด',
          onSeeAll: () {},
        ),
        const SizedBox(height: 14),

        // 2-column grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: products.length > 4 ? 4 : products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                isWishlisted: controller.isWishlisted(product.id),
                onWishlistToggle: () =>
                    controller.toggleWishlist(product.id),
                onTap: () => _showProductDetail(product),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Bottom Navigation ─────────────────────────────────────────────────────────

  Widget _buildBottomNavBar() {
    return Consumer<CartController>(
      builder: (context, cart, _) {
        return BottomNavigationBar(
          currentIndex: _selectedNavIndex,
          onTap: (index) {
            if (_selectedNavIndex != index) {
              setState(() => _selectedNavIndex = index);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textHint,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          iconSize: 22,
          elevation: 16,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search_outlined),
              activeIcon: const Icon(Icons.search_rounded),
              label: 'ค้นหา',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cart.itemCount > 0,
                label: Text('${cart.itemCount}'),
                backgroundColor: AppColors.badge,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cart.itemCount > 0,
                label: Text('${cart.itemCount}'),
                backgroundColor: AppColors.badge,
                child: const Icon(Icons.shopping_cart_rounded),
              ),
              label: 'ตะกร้า',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long_rounded),
              label: 'คำสั่งซื้อ',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'โปรไฟล์',
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavBar_UNUSED() {
    return Consumer<CartController>(
      builder: (context, cart, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 56,
              child: Row(
                children: List.generate(_navItems.length, (index) {
                  final item = _navItems[index];
                  final isSelected = _selectedNavIndex == index;
                  final isCart = index == 2;
                  final cartCount = cart.itemCount;

                  return Expanded(
                    child: _NavBarItem(
                      icon: isSelected ? item.icon : item.outlineIcon,
                      label: item.label,
                      isSelected: isSelected,
                      badgeCount: isCart ? cartCount : 0,
                      onTap: () {
                        if (_selectedNavIndex != index) {
                          setState(() => _selectedNavIndex = index);
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Floating Cart FAB ─────────────────────────────────────────────────────────

  Widget _buildCartFab() {
    return Consumer<CartController>(
      builder: (context, cart, _) {
        if (cart.isEmpty) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () => setState(() => _selectedNavIndex = 2),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          icon: Badge(
            backgroundColor: AppColors.badge,
            label: Text(
              '${cart.itemCount}',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
            child: const Icon(Icons.shopping_cart_rounded, size: 20),
          ),
          label: Text(
            '฿${cart.totalPrice.toStringAsFixed(0)}',
            style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
          ),
        );
      },
    );
  }

  // ── Stub Screens (placeholder for other nav tabs) ─────────────────────────────

  Widget _buildStubScreen(int index) {
    final items = [
      const _StubData('🔍', 'ค้นหาสินค้า', 'ค้นหาปุ๋ย อุปกรณ์ และสินค้าเกษตรทุกชนิด'),
      const _StubData('🛒', 'ตะกร้าสินค้า', 'รายการสินค้าที่คุณเลือกไว้'),
      const _StubData('📦', 'คำสั่งซื้อ', 'ติดตามสถานะคำสั่งซื้อของคุณ'),
      const _StubData('👨‍🌾', 'โปรไฟล์', 'ข้อมูลบัญชีและการตั้งค่า'),
    ];

    final data = index > 0 && index <= items.length
        ? items[index - 1]
        : const _StubData('🌾', 'กำลังพัฒนา', 'หน้านี้กำลังพัฒนา');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          data.title,
          style: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data.emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(data.title, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                data.subtitle,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => setState(() => _selectedNavIndex = 0),
                child: const Text('กลับหน้าหลัก'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sheets & Dialogs ──────────────────────────────────────────────────────────

  void _showNotificationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NotificationSheet(),
    );
  }

  void _showKnowledgeHubSheet() {
    final tips = context.read<HomeController>().tips;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _KnowledgeHubSheet(tips: tips),
    );
  }

  void _showProductDetail(ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ProductDetailSheet(product: product),
    );
  }
}

// =============================================================================
//  Private widgets used exclusively in HomeView
// =============================================================================

// ─── Nav item data class ──────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final IconData outlineIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.outlineIcon,
    required this.label,
  });
}

// ─── Bottom nav bar item ──────────────────────────────────────────────────────

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with optional badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textHint,
                  ),
                ),

                if (badgeCount > 0)
                  Positioned(
                    top: -2,
                    right: -4,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColors.badge,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.surface,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          badgeCount > 99 ? '99+' : '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 2),

            // Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.navLabel.copyWith(
                fontSize: 10,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textHint,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stub screen data ─────────────────────────────────────────────────────────

class _StubData {
  final String emoji;
  final String title;
  final String subtitle;

  const _StubData(this.emoji, this.title, this.subtitle);
}

// =============================================================================
//  Notification Bottom Sheet
// =============================================================================

class _NotificationSheet extends StatelessWidget {
  final List<_MockNotification> _notifications = const [
    _MockNotification(
      emoji: '🎉',
      title: 'โปรโมชันสมาชิก 30% ลดทันที',
      subtitle: 'สำหรับสมาชิกทุกท่านวันนี้เท่านั้น!',
      time: '5 นาทีที่แล้ว',
      isNew: true,
    ),
    _MockNotification(
      emoji: '🚚',
      title: 'คำสั่งซื้อ #FP2024-001 กำลังจัดส่ง',
      subtitle: 'ปุ๋ยอินทรีย์ชีวภาพ 2 ถุง กำลังเดินทาง',
      time: '1 ชั่วโมงที่แล้ว',
      isNew: true,
    ),
    _MockNotification(
      emoji: '📦',
      title: 'สินค้าของคุณถึงแล้ว!',
      subtitle: 'คำสั่งซื้อ #FP2024-000 จัดส่งสำเร็จ',
      time: 'เมื่อวาน',
      isNew: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Text('การแจ้งเตือน', style: AppTextStyles.headlineSmall),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ปิด'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 72,
                endIndent: 20,
              ),
              itemBuilder: (_, index) {
                final n = _notifications[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: n.isNew
                          ? AppColors.primaryContainer
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        n.emoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  title: Text(
                    n.title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: n.isNew
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        n.subtitle,
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(n.time, style: AppTextStyles.bodySmall),
                    ],
                  ),
                  trailing: n.isNew
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MockNotification {
  final String emoji;
  final String title;
  final String subtitle;
  final String time;
  final bool isNew;

  const _MockNotification({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isNew,
  });
}

// =============================================================================
//  Knowledge Hub Bottom Sheet
// =============================================================================

class _KnowledgeHubSheet extends StatelessWidget {
  final List tips;

  const _KnowledgeHubSheet({required this.tips});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    const Text('📚', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ความรู้เกษตร',
                            style: AppTextStyles.headlineSmall,
                          ),
                          Text(
                            'เคล็ดลับจากผู้เชี่ยวชาญ ${tips.length} บทความ',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: AppColors.divider),

              // Tips list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  itemCount: tips.length,
                  itemBuilder: (context, index) {
                    final tip = tips[index];
                    return TipListCard(
                      tip: tip,
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
//  Product Detail Bottom Sheet
// =============================================================================

class _ProductDetailSheet extends StatefulWidget {
  final ProductModel product;

  const _ProductDetailSheet({required this.product});

  @override
  State<_ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends State<_ProductDetailSheet> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final bgColor = getProductCategoryColor(product.categoryId);
    final cart = context.watch<CartController>();
    final inCart = cart.contains(product.id);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Emoji hero ──────────────────────────────────────────
                      Center(
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              product.imageEmoji,
                              style: const TextStyle(fontSize: 72),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Badges row ─────────────────────────────────────────
                      Row(
                        children: [
                          if (product.isBestSeller)
                            _badge('🔥 ขายดี', AppColors.accent,
                                AppColors.textPrimary),
                          if (product.hasDiscount) ...[
                            const SizedBox(width: 8),
                            _badge(
                              '-${product.discountPercent.toInt()}%',
                              AppColors.error,
                              Colors.white,
                            ),
                          ],
                          if (product.isOnSale) ...[
                            const SizedBox(width: 8),
                            _badge('🏷️ โปรโมชัน', AppColors.primaryContainer,
                                AppColors.primary),
                          ],
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ── Product name ───────────────────────────────────────
                      Text(product.name, style: AppTextStyles.headlineMedium),

                      const SizedBox(height: 4),

                      // ── Unit + Rating ──────────────────────────────────────
                      Row(
                        children: [
                          Text(product.unit, style: AppTextStyles.bodySmall),
                          const SizedBox(width: 12),
                          const Icon(Icons.star_rounded,
                              color: AppColors.accent, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: AppTextStyles.ratingText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${product.reviewCount} รีวิว)',
                            style: AppTextStyles.reviewCount,
                          ),
                          const Spacer(),
                          // Stock
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: product.stock > 0
                                  ? AppColors.primaryContainer
                                  : const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.stock > 0
                                  ? 'สต็อก ${product.stock}'
                                  : 'สินค้าหมด',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: product.stock > 0
                                    ? AppColors.primary
                                    : AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── Price ──────────────────────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('฿', style: AppTextStyles.priceSmall),
                          const SizedBox(width: 2),
                          Text(
                            product.price.toStringAsFixed(0),
                            style: AppTextStyles.priceLarge,
                          ),
                          const SizedBox(width: 10),
                          if (product.hasDiscount)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '฿${product.originalPrice!.toStringAsFixed(0)}',
                                style: AppTextStyles.priceOriginal.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const Divider(height: 28, color: AppColors.divider),

                      // ── Description ────────────────────────────────────────
                      Text('รายละเอียดสินค้า',
                          style: AppTextStyles.titleLarge),
                      const SizedBox(height: 8),
                      Text(product.description, style: AppTextStyles.bodyMedium),

                      const SizedBox(height: 16),

                      // ── Tags ───────────────────────────────────────────────
                      if (product.tags.isNotEmpty) ...[
                        Text('แท็ก', style: AppTextStyles.titleSmall),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: product.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '#$tag',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // ── Quantity selector ──────────────────────────────────
                      if (!inCart && product.stock > 0) ...[
                        const Divider(height: 1, color: AppColors.divider),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text('จำนวน', style: AppTextStyles.titleMedium),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _stepBtn(Icons.remove, () {
                                    if (_quantity > 1) {
                                      setState(() => _quantity--);
                                    }
                                  }),
                                  SizedBox(
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        '$_quantity',
                                        style:
                                            AppTextStyles.titleLarge.copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  _stepBtn(Icons.add, () {
                                    if (_quantity < product.stock) {
                                      setState(() => _quantity++);
                                    }
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ),

              // ── Bottom action bar ───────────────────────────────────────────
              Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  MediaQuery.of(context).padding.bottom + 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowDark,
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Wishlist button
                    Consumer<HomeController>(
                      builder: (ctx, ctrl, _) {
                        final wishlisted = ctrl.isWishlisted(product.id);
                        return GestureDetector(
                          onTap: () => ctrl.toggleWishlist(product.id),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: wishlisted
                                  ? const Color(0xFFFFEBEE)
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: wishlisted
                                    ? Colors.red.withOpacity(0.3)
                                    : AppColors.divider,
                              ),
                            ),
                            child: Icon(
                              wishlisted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: wishlisted
                                  ? Colors.red
                                  : AppColors.textHint,
                              size: 22,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(width: 12),

                    // Add to cart / In cart button
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: inCart
                            ? OutlinedButton.icon(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: AppColors.primary, width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  minimumSize: Size.zero,
                                ),
                                icon: const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 20),
                                label: Text(
                                  'อยู่ในตะกร้าแล้ว (${cart.getQuantity(product.id)} ชิ้น)',
                                  style: AppTextStyles.buttonMedium.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: product.stock == 0
                                    ? null
                                    : () {
                                        context.read<CartController>().addToCart(
                                              product,
                                              quantity: _quantity,
                                            );
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'เพิ่ม ${product.name} ในตะกร้าแล้ว'),
                                            backgroundColor:
                                                AppColors.primaryDark,
                                            behavior:
                                                SnackBarBehavior.floating,
                                            margin: const EdgeInsets.fromLTRB(
                                                16, 0, 16, 16),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                ),
                                icon: const Icon(
                                    Icons.add_shopping_cart_rounded,
                                    size: 20),
                                label: Text(
                                  'ใส่ตะกร้า  •  ฿${(product.price * _quantity).toStringAsFixed(0)}',
                                  style: AppTextStyles.buttonMedium,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _badge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _stepBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
