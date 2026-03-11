// ─────────────────────────────────────────────────────────────────────────────
//  views/product/product_list_view.dart
//  Full product listing screen with live search, category chips, and grid.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/home_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/product_model.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/product/product_card.dart';

class ProductListView extends StatefulWidget {
  /// Optional pre-selected category id passed from the home screen.
  final String? initialCategoryId;

  const ProductListView({super.key, this.initialCategoryId});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView>
    with SingleTickerProviderStateMixin {
  // ── Controllers / state ────────────────────────────────────────────────────
  late final TextEditingController _searchCtrl;
  late final FocusNode _searchFocus;
  late final ScrollController _scrollCtrl;

  // Sort options
  _SortOption _sortOption = _SortOption.popular;

  // Layout toggle
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
    _searchFocus = FocusNode();
    _scrollCtrl = ScrollController();

    // Apply pre-selected category if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<HomeController>();
      if (widget.initialCategoryId != null &&
          widget.initialCategoryId != ctrl.selectedCategoryId) {
        ctrl.selectCategory(widget.initialCategoryId);
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Sort products ──────────────────────────────────────────────────────────
  List<ProductModel> _sortProducts(List<ProductModel> source) {
    final list = List<ProductModel>.from(source);
    switch (_sortOption) {
      case _SortOption.popular:
        list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      case _SortOption.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
      case _SortOption.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
      case _SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case _SortOption.newest:
        break; // keep original insertion order as "newest"
    }
    return list;
  }

  // ── Scroll to top helper ───────────────────────────────────────────────────
  void _scrollToTop() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<HomeController>(
        builder: (context, ctrl, _) {
          // Decide which product list to display
          final rawProducts = ctrl.isSearching
              ? ctrl.searchResults
              : _sortProducts(ctrl.filteredProducts);

          return NestedScrollView(
            controller: _scrollCtrl,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildSliverAppBar(context, ctrl, innerBoxIsScrolled),
            ],
            body: rawProducts.isEmpty
                ? _buildEmptyState(ctrl)
                : _buildProductBody(context, rawProducts, ctrl),
          );
        },
      ),
    );
  }

  // ── Sliver App Bar ─────────────────────────────────────────────────────────
  Widget _buildSliverAppBar(
    BuildContext context,
    HomeController ctrl,
    bool innerBoxIsScrolled,
  ) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      expandedHeight: 180,
      backgroundColor: AppColors.headerMid,
      foregroundColor: Colors.white,
      elevation: innerBoxIsScrolled ? 4 : 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.pop(context),
        tooltip: 'กลับ',
      ),
      actions: [
        // Cart icon with badge
        Consumer<CartController>(
          builder: (_, cart, __) => Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  // Navigate to cart
                },
              ),
              if (cart.itemCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppColors.badge,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        cart.itemCount > 99 ? '99+' : '${cart.itemCount}',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeaderBackground(ctrl),
        collapseMode: CollapseMode.pin,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: _buildFilterBar(ctrl),
      ),
    );
  }

  // ── Header background inside the sliver ────────────────────────────────────
  Widget _buildHeaderBackground(HomeController ctrl) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.headerDark, AppColors.headerMid],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 72, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Title
          Text(
            ctrl.selectedCategoryId != null
                ? _getCategoryName(ctrl)
                : 'สินค้าทั้งหมด',
            style: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),

          // Product count
          Text(
            '${ctrl.filteredProducts.length} รายการ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 12),

          // Search bar
          _SearchBarEmbedded(
            controller: _searchCtrl,
            focusNode: _searchFocus,
            onChanged: (q) {
              ctrl.updateSearchQuery(q);
              _scrollToTop();
            },
            onClear: () {
              ctrl.clearSearch();
              _scrollToTop();
            },
          ),
        ],
      ),
    );
  }

  // ── Category chip filter bar ───────────────────────────────────────────────
  Widget _buildFilterBar(HomeController ctrl) {
    return Container(
      color: AppColors.headerMid,
      child: SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            // "ทั้งหมด" chip
            _CategoryFilterChip(
              label: 'ทั้งหมด',
              emoji: '🛒',
              isSelected: ctrl.selectedCategoryId == null,
              onTap: () {
                ctrl.clearCategoryFilter();
                _scrollToTop();
              },
            ),
            const SizedBox(width: 6),
            ...ctrl.categories.map((cat) {
              final selected = ctrl.selectedCategoryId == cat.id;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _CategoryFilterChip(
                  label: cat.name,
                  emoji: cat.emoji,
                  isSelected: selected,
                  onTap: () {
                    ctrl.selectCategory(cat.id);
                    _scrollToTop();
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── Toolbar: sort + layout toggle ─────────────────────────────────────────
  Widget _buildToolbar(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Result count
          Expanded(
            child: Text(
              'พบ $count รายการ',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),

          // Sort button
          GestureDetector(
            onTap: _showSortSheet,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sort_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _sortOption.label,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.expand_more_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Layout toggle
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.divider),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LayoutToggleButton(
                  icon: Icons.grid_view_rounded,
                  isActive: _isGridView,
                  onTap: () => setState(() => _isGridView = true),
                  isLeft: true,
                ),
                _LayoutToggleButton(
                  icon: Icons.view_list_rounded,
                  isActive: !_isGridView,
                  onTap: () => setState(() => _isGridView = false),
                  isLeft: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Main product body ──────────────────────────────────────────────────────
  Widget _buildProductBody(
    BuildContext context,
    List<ProductModel> products,
    HomeController ctrl,
  ) {
    return CustomScrollView(
      slivers: [
        // Toolbar
        SliverToBoxAdapter(child: _buildToolbar(products.length)),

        // Best sellers section header (only when not filtering)
        if (!ctrl.isSearching && ctrl.selectedCategoryId == null)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: 'สินค้าขายดี 🔥',
                  subtitle: 'สินค้าที่เกษตรกรนิยมสั่งซื้อมากที่สุด',
                  seeAllLabel: 'ดูทั้งหมด',
                  onSeeAll: () {},
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),

        // Grid or List
        _isGridView
            ? _buildProductGrid(context, products, ctrl)
            : _buildProductList(context, products, ctrl),

        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  // ── Grid layout ────────────────────────────────────────────────────────────
  Widget _buildProductGrid(
    BuildContext context,
    List<ProductModel> products,
    HomeController ctrl,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              isWishlisted: ctrl.isWishlisted(product.id),
              onWishlistToggle: () => ctrl.toggleWishlist(product.id),
              onTap: () => _navigateToDetail(context, product),
            );
          },
          childCount: products.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.72,
        ),
      ),
    );
  }

  // ── List layout ────────────────────────────────────────────────────────────
  Widget _buildProductList(
    BuildContext context,
    List<ProductModel> products,
    HomeController ctrl,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ProductListTile(
                product: product,
                isWishlisted: ctrl.isWishlisted(product.id),
                onWishlistToggle: () => ctrl.toggleWishlist(product.id),
                onTap: () => _navigateToDetail(context, product),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────
  Widget _buildEmptyState(HomeController ctrl) {
    final isSearch = ctrl.isSearching;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isSearch ? '🔍' : '📦',
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 20),
            Text(
              isSearch
                  ? 'ไม่พบสินค้าที่ค้นหา'
                  : 'ยังไม่มีสินค้าในหมวดนี้',
              style: AppTextStyles.emptyStateTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isSearch
                  ? 'ลองค้นหาด้วยคำอื่น หรือเลือกหมวดหมู่ใหม่'
                  : 'กลับมาใหม่เร็วๆ นี้ กำลังเพิ่มสินค้า',
              style: AppTextStyles.emptyStateSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 180,
              child: ElevatedButton.icon(
                onPressed: () {
                  ctrl.clearSearch();
                  ctrl.clearCategoryFilter();
                  _searchCtrl.clear();
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('ดูสินค้าทั้งหมด'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sort bottom sheet ──────────────────────────────────────────────────────
  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'เรียงลำดับสินค้า',
                    style: AppTextStyles.headlineSmall,
                  ),
                ),

                const SizedBox(height: 8),
                const Divider(indent: 20, endIndent: 20),

                ..._SortOption.values.map((option) {
                  final isSelected = _sortOption == option;
                  return ListTile(
                    leading: Icon(
                      option.icon,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 22,
                    ),
                    title: Text(
                      option.label,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded,
                            color: AppColors.primary, size: 20)
                        : null,
                    onTap: () {
                      setState(() => _sortOption = option);
                      Navigator.pop(ctx);
                      _scrollToTop();
                    },
                  );
                }),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Navigation ─────────────────────────────────────────────────────────────
  void _navigateToDetail(BuildContext context, ProductModel product) {
    // TODO: push ProductDetailView
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เปิดสินค้า: ${product.name}'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ── Helper: category name from id ─────────────────────────────────────────
  String _getCategoryName(HomeController ctrl) {
    try {
      return ctrl.categories
          .firstWhere((c) => c.id == ctrl.selectedCategoryId)
          .name;
    } catch (_) {
      return 'สินค้าทั้งหมด';
    }
  }
}

// ─── Embedded Search Bar ──────────────────────────────────────────────────────

class _SearchBarEmbedded extends StatelessWidget {
  const _SearchBarEmbedded({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: AppTextStyles.searchInput.copyWith(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'ค้นหาสินค้า...',
          hintStyle: AppTextStyles.searchHint.copyWith(
            color: Colors.white.withOpacity(0.6),
          ),
          border: InputBorder.none,
          filled: false,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white.withOpacity(0.8),
            size: 20,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () {
                  controller.clear();
                  onClear();
                },
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 18,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─── Category filter chip ─────────────────────────────────────────────────────

class _CategoryFilterChip extends StatelessWidget {
  const _CategoryFilterChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : Colors.white,
                fontWeight: isSelected
                    ? FontWeight.w700
                    : FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Product List Tile (list-view mode) ───────────────────────────────────────

class _ProductListTile extends StatelessWidget {
  const _ProductListTile({
    required this.product,
    required this.isWishlisted,
    required this.onWishlistToggle,
    required this.onTap,
  });

  final ProductModel product;
  final bool isWishlisted;
  final VoidCallback onWishlistToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = getProductCategoryColor(product.categoryId);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // ── Emoji image ────────────────────────────────────────────────
            Container(
              width: 110,
              color: bgColor,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      product.imageEmoji,
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                  if (product.hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '-${product.discountPercent.toInt()}%',
                          style: AppTextStyles.discountBadge
                              .copyWith(fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Info ───────────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top row: name + wishlist
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: AppTextStyles.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: onWishlistToggle,
                          child: Icon(
                            isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18,
                            color: isWishlisted
                                ? Colors.red
                                : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),

                    // Unit + rating
                    Row(
                      children: [
                        Text(
                          product.unit,
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.star_rounded,
                            color: AppColors.accent, size: 13),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: AppTextStyles.ratingText,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '(${product.reviewCount})',
                          style: AppTextStyles.reviewCount,
                        ),
                      ],
                    ),

                    // Price + cart button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Price column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text('฿',
                                    style: AppTextStyles.priceSmall),
                                const SizedBox(width: 1),
                                Text(
                                  product.price.toStringAsFixed(0),
                                  style: AppTextStyles.priceMedium,
                                ),
                              ],
                            ),
                            if (product.hasDiscount)
                              Text(
                                '฿${product.originalPrice!.toStringAsFixed(0)}',
                                style: AppTextStyles.priceOriginal,
                              ),
                          ],
                        ),

                        // Add to cart mini button
                        Consumer<CartController>(
                          builder: (ctx, cart, _) {
                            final inCart = cart.contains(product.id);
                            final qty = cart.getQuantity(product.id);

                            if (inCart) {
                              return _MiniStepper(
                                qty: qty,
                                onDecrease: () =>
                                    cart.decreaseQuantity(product.id),
                                onIncrease: () =>
                                    cart.increaseQuantity(product.id),
                              );
                            }

                            return GestureDetector(
                              onTap: () {
                                cart.addToCart(product);
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'เ
