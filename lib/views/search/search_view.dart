import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/product_model.dart';
import '../../widgets/product/product_card.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;

  // Recent search tags (mock data — replace with shared prefs later)
  final List<String> _recentSearches = [
    'ปุ๋ยอินทรีย์',
    'ยาฆ่าแมลง',
    'เมล็ดพันธุ์',
    'ปุ๋ยน้ำ',
    'ฮิวมิค แอซิด',
  ];

  final List<String> _popularKeywords = [
    '🌱 ปุ๋ยอินทรีย์',
    '🧪 ปุ๋ยเคมี 15-15-15',
    '💧 ปุ๋ยน้ำ',
    '🐛 กำจัดแมลง',
    '🌽 เมล็ดข้าวโพด',
    '🍅 เมล็ดมะเขือเทศ',
    '🌾 ฮิวมิค แอซิด',
    '🔧 อุปกรณ์การเกษตร',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();

    // Auto-focus search bar when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<HomeController>().updateSearchQuery(query);
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      _addToRecent(query.trim());
    }
  }

  void _onKeywordTap(String keyword) {
    // Strip leading emoji + space if present
    final clean = keyword.replaceFirst(RegExp(r'^[\u{1F300}-\u{1FAFF}\s]+', unicode: true), '').trim();
    _searchController.text = clean;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: clean.length),
    );
    _onSearchChanged(clean);
    _addToRecent(clean);
  }

  void _addToRecent(String query) {
    setState(() {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 8) {
        _recentSearches.removeLast();
      }
    });
  }

  void _clearRecent() {
    setState(() => _recentSearches.clear());
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<HomeController>().clearSearch();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Search Header ───────────────────────────────────────────────────
          _buildSearchHeader(context),

          // ── Body ────────────────────────────────────────────────────────────
          Expanded(
            child: Consumer<HomeController>(
              builder: (context, controller, _) {
                if (controller.isSearching) {
                  return _buildSearchResults(context, controller);
                }
                return _buildDiscoveryContent();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Header ───────────────────────────────────────────────────────────

  Widget _buildSearchHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.headerDark, AppColors.headerMid],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Search field
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    onChanged: _onSearchChanged,
                    onSubmitted: _onSearchSubmitted,
                    textInputAction: TextInputAction.search,
                    style: AppTextStyles.searchInput.copyWith(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'ค้นหาปุ๋ย อุปกรณ์ สารกำจัดศัตรูพืช...',
                      hintStyle: AppTextStyles.searchHint.copyWith(
                        color: Colors.white.withOpacity(0.55),
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Colors.white70,
                        size: 22,
                      ),
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (_, value, __) {
                          if (value.text.isEmpty) return const SizedBox.shrink();
                          return GestureDetector(
                            onTap: _clearSearch,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          );
                        },
                      ),
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Discovery Content (no query) ─────────────────────────────────────────────

  Widget _buildDiscoveryContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Recent searches
          if (_recentSearches.isNotEmpty) ...[
            _buildSectionTitle(
              title: 'ค้นหาล่าสุด',
              icon: Icons.history_rounded,
              trailing: TextButton(
                onPressed: _clearRecent,
                child: Text(
                  'ลบทั้งหมด',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildRecentChips(),
            const SizedBox(height: 24),
          ],

          // Popular searches
          _buildSectionTitle(
            title: 'ค้นหายอดนิยม',
            icon: Icons.trending_up_rounded,
          ),
          const SizedBox(height: 10),
          _buildPopularGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required IconData icon,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.headlineSmall),
          const Spacer(),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildRecentChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _recentSearches.map((keyword) {
          return GestureDetector(
            onTap: () => _onKeywordTap(keyword),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                  const Icon(Icons.history_rounded,
                      size: 14, color: AppColors.textHint),
                  const SizedBox(width: 6),
                  Text(keyword, style: AppTextStyles.labelMedium),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPopularGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _popularKeywords.map((keyword) {
          return GestureDetector(
            onTap: () => _onKeywordTap(keyword),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Text(
                keyword,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Search Results ─────────────────────────────────────────────────────────

  Widget _buildSearchResults(
    BuildContext context,
    HomeController controller,
  ) {
    final results = controller.searchResults;
    final query = controller.searchQuery;

    if (results.isEmpty) {
      return _buildEmptyState(query);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Result count chip
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'พบ ${results.length} รายการ',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'สำหรับ "$query"',
                  style: AppTextStyles.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Grid of results
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final product = results[index];
              return Consumer<HomeController>(
                builder: (ctx, ctrl, _) => ProductCard(
                  product: product,
                  isWishlisted: ctrl.isWishlisted(product.id),
                  onWishlistToggle: () => ctrl.toggleWishlist(product.id),
                  onTap: () => _openProductDetail(context, product),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Empty State ─────────────────────────────────────────────────────────────

  Widget _buildEmptyState(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🔍', style: TextStyle(fontSize: 46)),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'ไม่พบสินค้า',
              style: AppTextStyles.emptyStateTitle,
            ),
            const SizedBox(height: 8),
            Text(
              'ไม่มีผลลัพธ์สำหรับ "$query"\nลองค้นหาด้วยคำอื่น',
              style: AppTextStyles.emptyStateSubtitle,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            // Suggestions
            Text(
              'ลองค้นหา:',
              style: AppTextStyles.titleSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _popularKeywords.take(4).map((kw) {
                return GestureDetector(
                  onTap: () => _onKeywordTap(kw),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      kw,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Navigation ──────────────────────────────────────────────────────────────

  void _openProductDetail(BuildContext context, ProductModel product) {
    // TODO: Navigate to product detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เปิดสินค้า: ${product.name}'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
