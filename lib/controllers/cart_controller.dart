// ─────────────────────────────────────────────
//  controllers/cart_controller.dart
//  Manages shopping cart state with ChangeNotifier
// ─────────────────────────────────────────────

import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

// ─── CartItem ─────────────────────────────────────────────────────────────────

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get subtotal => product.price * quantity;

  CartItem copyWith({ProductModel? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItem && other.product.id == product.id);

  @override
  int get hashCode => product.id.hashCode;

  @override
  String toString() =>
      'CartItem(product: ${product.name}, qty: $quantity, subtotal: $subtotal)';
}

// ─── CartController ───────────────────────────────────────────────────────────

class CartController extends ChangeNotifier {
  // Internal list of cart items
  final List<CartItem> _items = [];

  // ── Getters ──────────────────────────────────────────────────────────────────

  /// Read-only view of cart items
  List<CartItem> get items => List.unmodifiable(_items);

  /// Total number of individual product lines in the cart
  int get lineCount => _items.length;

  /// Total quantity of all items summed together (for badge display)
  int get itemCount =>
      _items.fold(0, (total, item) => total + item.quantity);

  /// Whether the cart is empty
  bool get isEmpty => _items.isEmpty;

  /// Whether the cart has items
  bool get isNotEmpty => _items.isNotEmpty;

  /// Subtotal before any fee
  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.subtotal);

  /// Shipping fee logic: free if subtotal >= 8500, otherwise 60 ฿
  double get shippingFee => subtotal >= 8500.0 ? 0.0 : 60.0;

  /// Final total
  double get totalPrice => subtotal + shippingFee;

  /// Amount remaining to qualify for free shipping
  double get amountForFreeShipping =>
      subtotal >= 8500.0 ? 0.0 : 8500.0 - subtotal;

  /// Whether the order qualifies for free shipping
  bool get hasFreeShipping => subtotal >= 8500.0;

  // ── Query helpers ─────────────────────────────────────────────────────────────

  /// Returns the CartItem for a given product id, or null if not in cart
  CartItem? getItem(String productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (_) {
      return null;
    }
  }

  /// Returns the quantity of a product in the cart (0 if not present)
  int getQuantity(String productId) => getItem(productId)?.quantity ?? 0;

  /// Whether a product is already in the cart
  bool contains(String productId) => getItem(productId) != null;

  // ── Mutating actions ──────────────────────────────────────────────────────────

  /// Add a product to the cart. If it already exists, increments quantity.
  void addToCart(ProductModel product, {int quantity = 1}) {
    assert(quantity > 0, 'Quantity must be greater than 0');

    final existingIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      final newQty = existing.quantity + quantity;

      // Respect stock limit
      final capped = product.stock > 0
          ? newQty.clamp(1, product.stock)
          : newQty;

      _items[existingIndex] = existing.copyWith(quantity: capped);
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
  }

  /// Decrease quantity by 1. Removes the item if quantity reaches 0.
  void decreaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    if (_items[index].quantity <= 1) {
      _items.removeAt(index);
    } else {
      _items[index] =
          _items[index].copyWith(quantity: _items[index].quantity - 1);
    }

    notifyListeners();
  }

  /// Increase quantity by 1 (respects stock limit).
  void increaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    final item = _items[index];
    final stock = item.product.stock;
    final newQty = item.quantity + 1;

    if (stock > 0 && newQty > stock) return; // already at max stock

    _items[index] = item.copyWith(quantity: newQty);
    notifyListeners();
  }

  /// Set an explicit quantity for a product. Removes if quantity is 0.
  void setQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    final item = _items[index];
    final stock = item.product.stock;
    final capped = stock > 0 ? quantity.clamp(1, stock) : quantity;

    _items[index] = item.copyWith(quantity: capped);
    notifyListeners();
  }

  /// Remove a product entirely from the cart.
  void removeFromCart(String productId) {
    final lengthBefore = _items.length;
    _items.removeWhere((item) => item.product.id == productId);
    if (_items.length < lengthBefore) notifyListeners();
  }

  /// Remove all items from the cart.
  void clearCart() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }

  // ── Order helpers ─────────────────────────────────────────────────────────────

  /// Returns a formatted summary string for debugging / order confirmation.
  String get orderSummary {
    final buffer = StringBuffer();
    for (final item in _items) {
      buffer.writeln(
          '• ${item.product.name} x${item.quantity} = ฿${item.subtotal.toStringAsFixed(0)}');
    }
    buffer.writeln('──────────────────────');
    buffer.writeln('ยอดรวม: ฿${subtotal.toStringAsFixed(0)}');
    buffer.writeln(
        'ค่าจัดส่ง: ${hasFreeShipping ? "ฟรี" : "฿${shippingFee.toStringAsFixed(0)}"}');
    buffer.writeln('รวมทั้งสิ้น: ฿${totalPrice.toStringAsFixed(0)}');
    return buffer.toString();
  }

  @override
  String toString() =>
      'CartController(items: $lineCount, total: ฿${totalPrice.toStringAsFixed(0)})';
}
