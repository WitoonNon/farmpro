import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/product_model.dart';
import '../../views/cart/cart_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  widgets/product/product_card.dart
//  Reusable card that displays a product with emoji, price, discount badge,
//  star rating, stock status, and an animated Add-to-Cart button.
// ─────────────────────────────────────────────────────────────────────────────

class ProductCard extends StatefulWidget {
  final ProductModel product;

  /// Called when the card body (not the button) is tapped.
  final VoidCallback? onTap;

  /// Called when the wishlist heart icon is tapped.
  final VoidCallback? onWishlistToggle;

  /// Whether this product is currently in the user's wishlist.
  final bool isWishlisted;

  /// Compact mode – smaller card for horizontal lists.
  final bool compact;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onWishlistToggle,
    this.isWishlisted = false,
    this.compact = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _animateAndAddToCart(BuildContext context) async {
    await _bounceController.forward();
    await _bounceController.reverse();

    if (!context.mounted) return;

    final cart = context.read<CartController>();
    cart.addToCart(widget.product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(
              widget.product.imageEmoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'เพิ่ม "${widget.product.name}" ในตะกร้าแล้ว',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'ดูตะกร้า',
          textColor: AppColors.accentLight,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CartView(showBackButton: true),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.compact ? _buildCompactCard(context) : _buildFullCard(context);
  }

  // ── Full Card (grid / list) ──────────────────────────────────────────────────

  Widget _buildFullCard(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image / Emoji area ─────────────────────────────────────────────
            _buildImageArea(context, height: 110),

            // ── Info area ──────────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top section: name + unit + rating
                    Text(
                      widget.product.name,
                      style: AppTextStyles.titleMedium.copyWith(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      widget.product.unit,
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    _buildRatingRow(),

                    const Spacer(),

                    // Bottom section: price + button
                    _buildPriceRow(),
                    const SizedBox(height: 4),
                    _buildAddToCartButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Compact Card (horizontal scroll list) ──────────────────────────────────

  Widget _buildCompactCard(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 150,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji image
            _buildImageArea(context, height: 92),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    _buildRatingRow(compact: true),

                    const Spacer(),

                    _buildPriceRow(compact: true),
                    const SizedBox(height: 3),
                    _buildAddToCartButton(context, compact: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Image / Emoji Area ──────────────────────────────────────────────────────

  Widget _buildImageArea(BuildContext context, {required double height}) {
    final bgColor = getProductCategoryColor(widget.product.categoryId);

    return Stack(
      children: [
        // Background gradient
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                bgColor,
                Color.lerp(bgColor, Colors.white, 0.4) ?? bgColor,
              ],
            ),
          ),
          child: Center(
            child: Text(
              widget.product.imageEmoji,
              style: TextStyle(fontSize: height * 0.42),
            ),
          ),
        ),

        // Discount badge (top-left)
        if (widget.product.hasDiscount)
          Positioned(
            top: 8,
            left: 8,
            child: _buildDiscountBadge(),
          ),

        // Best Seller badge (top-left, below discount)
        if (widget.product.isBestSeller && !widget.product.hasDiscount)
          Positioned(
            top: 8,
            left: 8,
            child: _buildBestSellerBadge(),
          ),

        // Wishlist heart (top-right)
        Positioned(
          top: 4,
          right: 4,
          child: _buildWishlistButton(),
        ),

        // Out-of-stock overlay
        if (widget.product.stock == 0)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'สินค้าหมด',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ── Discount Badge ──────────────────────────────────────────────────────────

  Widget _buildDiscountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '-${widget.product.discountPercent.toInt()}%',
        style: AppTextStyles.discountBadge.copyWith(fontSize: 11),
      ),
    );
  }

  // ── Best Seller Badge ───────────────────────────────────────────────────────

  Widget _buildBestSellerBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 2),
          Text(
            'ขายดี',
            style: AppTextStyles.discountBadge.copyWith(
              fontSize: 10,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Wishlist Button ─────────────────────────────────────────────────────────

  Widget _buildWishlistButton() {
    return GestureDetector(
      onTap: widget.onWishlistToggle,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          widget.isWishlisted ? Icons.favorite : Icons.favorite_border,
          size: 16,
          color: widget.isWishlisted ? Colors.red : AppColors.textHint,
        ),
      ),
    );
  }

  // ── Rating Row ──────────────────────────────────────────────────────────────

  Widget _buildRatingRow({bool compact = false}) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: AppColors.accent, size: 14),
        const SizedBox(width: 2),
        Text(
          widget.product.rating.toStringAsFixed(1),
          style: AppTextStyles.ratingText,
        ),
        const SizedBox(width: 4),
        if (!compact)
          Text(
            '(${widget.product.reviewCount})',
            style: AppTextStyles.reviewCount,
          ),
      ],
    );
  }

  // ── Price Row ───────────────────────────────────────────────────────────────

  Widget _buildPriceRow({bool compact = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Current price
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('฿',
                style: AppTextStyles.priceSmall.copyWith(
                  fontSize: compact ? 11 : 13,
                )),
            const SizedBox(width: 1),
            Flexible(
              child: Text(
                _formatPrice(widget.product.price),
                style: compact
                    ? AppTextStyles.priceSmall.copyWith(fontSize: 14)
                    : AppTextStyles.priceMedium.copyWith(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        // Original price (strikethrough)
        if (widget.product.hasDiscount) ...[
          const SizedBox(height: 1),
          Text(
            '฿${_formatPrice(widget.product.originalPrice!)}',
            style: AppTextStyles.priceOriginal,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  // ── Add to Cart Button ──────────────────────────────────────────────────────

  Widget _buildAddToCartButton(BuildContext context, {bool compact = false}) {
    final cart = context.watch<CartController>();
    final inCart = cart.contains(widget.product.id);
    final qty = cart.getQuantity(widget.product.id);
    final outOfStock = widget.product.stock == 0;
    final btnHeight = compact ? 30.0 : 34.0;

    if (outOfStock) {
      return SizedBox(
        width: double.infinity,
        height: btnHeight,
        child: OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          child: Text(
            'สินค้าหมด',
            style: AppTextStyles.addToCartButton.copyWith(
              color: AppColors.textHint,
              fontSize: 11,
            ),
          ),
        ),
      );
    }

    // If item is already in cart – show quantity stepper
    if (inCart) {
      return _buildQuantityStepper(context, qty, compact: compact);
    }

    // Normal Add to Cart button
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: double.infinity,
        height: btnHeight,
        child: ElevatedButton.icon(
          onPressed: () => _animateAndAddToCart(context),
          style: ElevatedButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          icon: Icon(
            Icons.add_shopping_cart_rounded,
            size: compact ? 13 : 15,
          ),
          label: Text(
            'ใส่ตะกร้า',
            style: AppTextStyles.addToCartButton.copyWith(
              fontSize: compact ? 11 : 12,
            ),
          ),
        ),
      ),
    );
  }

  // ── Quantity Stepper ────────────────────────────────────────────────────────

  Widget _buildQuantityStepper(
    BuildContext context,
    int qty, {
    bool compact = false,
  }) {
    final cart = context.read<CartController>();
    final buttonSize = compact ? 24.0 : 28.0;
    final iconSize = compact ? 13.0 : 15.0;

    return Container(
      height: compact ? 30 : 34,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Decrease button
          _stepperButton(
            icon: Icons.remove,
            size: buttonSize,
            iconSize: iconSize,
            color: AppColors.primary,
            onTap: () => cart.decreaseQuantity(widget.product.id),
          ),

          // Quantity
          Expanded(
            child: Center(
              child: Text(
                '$qty',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 13 : 15,
                ),
              ),
            ),
          ),

          // Increase button
          _stepperButton(
            icon: Icons.add,
            size: buttonSize,
            iconSize: iconSize,
            color: AppColors.primary,
            onTap: () => cart.increaseQuantity(widget.product.id),
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({
    required IconData icon,
    required double size,
    required double iconSize,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  String _formatPrice(double price) {
    if (price >= 1000) {
      final thousands = price / 1000;
      if (thousands == thousands.truncate()) {
        return '${thousands.truncate()}k';
      }
      return thousands.toStringAsFixed(1) + 'k';
    }
    return price.toStringAsFixed(0);
  }
}
