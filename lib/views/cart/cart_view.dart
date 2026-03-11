import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/cart_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/product_model.dart';

class CartView extends StatelessWidget {
  /// Set to true when pushed via Navigator (shows back arrow).
  /// Set to false (default) when embedded in the bottom nav bar.
  final bool showBackButton;

  const CartView({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Consumer<CartController>(
        builder: (context, cart, _) {
          if (cart.isEmpty) {
            return _EmptyCartView();
          }
          return _buildCartBody(context, cart);
        },
      ),
    );
  }

  // ─── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.headerDark, AppColors.headerMid],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                if (showBackButton)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                    onPressed: () => Navigator.of(context).maybePop(),
                  )
                else
                  const SizedBox(width: 8),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '🛒 ตะกร้าสินค้า',
                    style: AppTextStyles.brandName.copyWith(fontSize: 18),
                  ),
                ),
                Consumer<CartController>(
                  builder: (_, cart, __) => cart.isNotEmpty
                      ? TextButton.icon(
                          onPressed: () => _confirmClearCart(context, cart),
                          icon: const Icon(Icons.delete_sweep_rounded,
                              color: Colors.white70, size: 18),
                          label: Text(
                            'ล้างทั้งหมด',
                            style: AppTextStyles.labelMedium
                                .copyWith(color: Colors.white70),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Body ──────────────────────────────────────────────────────────────────

  Widget _buildCartBody(BuildContext context, CartController cart) {
    return Column(
      children: [
        // Free-shipping progress strip
        _ShippingProgressStrip(cart: cart),

        // Item list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              return _CartItemTile(item: cart.items[index]);
            },
          ),
        ),

        // Order summary + checkout
        _OrderSummaryPanel(cart: cart),
      ],
    );
  }

  // ─── Confirm clear dialog ──────────────────────────────────────────────────

  void _confirmClearCart(BuildContext context, CartController cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('ล้างตะกร้า?'),
        content: const Text(
            'คุณต้องการลบสินค้าทั้งหมดออกจากตะกร้าหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              cart.clearCart();
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(80, 40),
            ),
            child: const Text('ล้างตะกร้า'),
          ),
        ],
      ),
    );
  }
}

// ─── Shipping Progress Strip ───────────────────────────────────────────────────

class _ShippingProgressStrip extends StatelessWidget {
  final CartController cart;

  const _ShippingProgressStrip({required this.cart});

  @override
  Widget build(BuildContext context) {
    final progress = (cart.subtotal / 8500.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cart.hasFreeShipping
            ? AppColors.primaryContainer
            : AppColors.accentLight,
        border: const Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                cart.hasFreeShipping ? '🚚' : '🛍️',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: cart.hasFreeShipping
                    ? Text(
                        'ยินดีด้วย! คุณได้รับสิทธิ์จัดส่งฟรี 🎉',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : RichText(
                        text: TextSpan(
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            const TextSpan(text: 'อีกเพียง '),
                            TextSpan(
                              text:
                                  '฿${cart.amountForFreeShipping.toStringAsFixed(0)}',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: AppColors.shippingOrange,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(text: ' เพื่อรับสิทธิ์ส่งฟรี'),
                          ],
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.6),
              valueColor: AlwaysStoppedAnimation<Color>(
                cart.hasFreeShipping
                    ? AppColors.primary
                    : AppColors.shippingOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Cart Item Tile ────────────────────────────────────────────────────────────

class _CartItemTile extends StatelessWidget {
  final CartItem item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartController>();
    final bgColor = getProductCategoryColor(item.product.categoryId);

    return Dismissible(
      key: ValueKey(item.product.id),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      confirmDismiss: (_) async {
        return await _confirmRemove(context);
      },
      onDismissed: (_) {
        cart.removeFromCart(item.product.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ลบ "${item.product.name}" ออกจากตะกร้าแล้ว',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.primaryDark,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'เลิกทำ',
              textColor: AppColors.accentLight,
              onPressed: () => cart.addToCart(item.product),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Emoji image ───────────────────────────────────────────────
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    item.product.imageEmoji,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ── Info ──────────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      item.product.name,
                      style: AppTextStyles.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Unit
                    Text(
                      item.product.unit,
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 8),

                    // Price + Stepper row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Price
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '฿${item.product.price.toStringAsFixed(0)}',
                                style: AppTextStyles.priceMedium,
                              ),
                              if (item.product.hasDiscount)
                                Text(
                                  '฿${item.product.originalPrice!.toStringAsFixed(0)}',
                                  style: AppTextStyles.priceOriginal,
                                ),
                            ],
                          ),
                        ),

                        // Quantity stepper
                        _QuantityStepper(item: item, cart: cart),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Subtotal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'รวม:',
                          style: AppTextStyles.bodySmall,
                        ),
                        Text(
                          '฿${item.subtotal.toStringAsFixed(0)}',
                          style: AppTextStyles.priceSmall.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
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

  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            'ลบ',
            style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmRemove(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('ลบสินค้า?'),
        content: Text(
          'ต้องการลบ "${item.product.name}" ออกจากตะกร้าหรือไม่?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(80, 40),
            ),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

// ─── Quantity Stepper ──────────────────────────────────────────────────────────

class _QuantityStepper extends StatelessWidget {
  final CartItem item;
  final CartController cart;

  const _QuantityStepper({required this.item, required this.cart});

  @override
  Widget build(BuildContext context) {
    final atMax =
        item.product.stock > 0 && item.quantity >= item.product.stock;

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease
          _stepButton(
            icon: item.quantity <= 1
                ? Icons.delete_outline_rounded
                : Icons.remove,
            color: item.quantity <= 1 ? AppColors.error : AppColors.primary,
            onTap: () => cart.decreaseQuantity(item.product.id),
          ),

          // Count
          SizedBox(
            width: 36,
            child: Center(
              child: Text(
                '${item.quantity}',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Increase
          _stepButton(
            icon: Icons.add,
            color: atMax ? AppColors.textHint : AppColors.primary,
            onTap: atMax ? null : () => cart.increaseQuantity(item.product.id),
          ),
        ],
      ),
    );
  }

  Widget _stepButton({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: onTap != null
              ? color.withOpacity(0.12)
              : AppColors.divider,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, color: onTap != null ? color : AppColors.textHint,
            size: 17),
      ),
    );
  }
}

// ─── Order Summary Panel ───────────────────────────────────────────────────────

class _OrderSummaryPanel extends StatelessWidget {
  final CartController cart;

  const _OrderSummaryPanel({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Summary rows ──────────────────────────────────────────────────
          _summaryRow(
            label: 'ยอดรวมสินค้า (${cart.itemCount} ชิ้น)',
            value: '฿${cart.subtotal.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 8),
          _summaryRow(
            label: 'ค่าจัดส่ง',
            value: cart.hasFreeShipping
                ? 'ฟรี 🎉'
                : '฿${cart.shippingFee.toStringAsFixed(0)}',
            valueColor: cart.hasFreeShipping
                ? AppColors.primary
                : AppColors.textSecondary,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.divider),
          ),

          // ── Total ─────────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('รวมทั้งสิ้น', style: AppTextStyles.titleLarge),
              Text(
                '฿${cart.totalPrice.toStringAsFixed(0)}',
                style: AppTextStyles.priceLarge,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Checkout button ───────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => _onCheckout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 3,
                shadowColor: AppColors.primary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_rounded, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'สั่งซื้อทันที  ฿${cart.totalPrice.toStringAsFixed(0)}',
                    style: AppTextStyles.buttonLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(
          value,
          style: AppTextStyles.titleSmall.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _onCheckout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CheckoutSheet(cart: cart),
    );
  }
}

// ─── Checkout Confirmation Sheet ───────────────────────────────────────────────

class _CheckoutSheet extends StatelessWidget {
  final CartController cart;

  const _CheckoutSheet({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🛒', style: TextStyle(fontSize: 34)),
            ),
          ),
          const SizedBox(height: 16),

          Text('ยืนยันการสั่งซื้อ', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'คำสั่งซื้อของคุณจะถูกดำเนินการทันที',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _sheetRow('จำนวนสินค้า', '${cart.itemCount} ชิ้น'),
                const SizedBox(height: 6),
                _sheetRow('ยอดรวม', '฿${cart.subtotal.toStringAsFixed(0)}'),
                const SizedBox(height: 6),
                _sheetRow(
                  'ค่าจัดส่ง',
                  cart.hasFreeShipping
                      ? 'ฟรี'
                      : '฿${cart.shippingFee.toStringAsFixed(0)}',
                ),
                const Divider(height: 16, color: AppColors.divider),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('รวมทั้งสิ้น',
                        style: AppTextStyles.titleLarge),
                    Text(
                      '฿${cart.totalPrice.toStringAsFixed(0)}',
                      style: AppTextStyles.priceMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Confirm button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                cart.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Text('✅', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Text(
                          'สั่งซื้อสำเร็จ! ขอบคุณที่ใช้บริการ FarmPro',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.primaryDark,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('ยืนยันสั่งซื้อ', style: AppTextStyles.buttonLarge),
            ),
          ),

          const SizedBox(height: 10),

          // Cancel
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.divider),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'ยกเลิก',
                style: AppTextStyles.buttonLarge
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sheetRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(value,
            style: AppTextStyles.titleSmall
                .copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─── Empty Cart View ───────────────────────────────────────────────────────────

class _EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🛒', style: TextStyle(fontSize: 54)),
              ),
            ),
            const SizedBox(height: 24),
            Text('ตะกร้าของคุณว่างเปล่า', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 10),
            Text(
              'เริ่มช้อปสินค้าเกษตรคุณภาพดี\nราคาถูก ส่งถึงหน้าไร่',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.storefront_rounded),
                label: const Text('เลือกซื้อสินค้า'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
