import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/promo_banner_model.dart';
import '../models/tip_model.dart';

class HomeController extends ChangeNotifier {
  // ─── Banner State ────────────────────────────────────────────────────────────
  int _currentBannerIndex = 0;
  int get currentBannerIndex => _currentBannerIndex;

  void setBannerIndex(int index) {
    if (_currentBannerIndex != index) {
      _currentBannerIndex = index;
      notifyListeners();
    }
  }

  // ─── Data Sources ────────────────────────────────────────────────────────────
  final List<PromoBannerModel> _banners = PromoBannerModel.getMockBanners();
  List<PromoBannerModel> get banners => List.unmodifiable(_banners);

  final List<CategoryModel> _categories = CategoryData.categories;
  List<CategoryModel> get categories => List.unmodifiable(_categories);

  final List<ProductModel> _allProducts = mockProducts;
  List<ProductModel> get bestSellers =>
      _allProducts.where((p) => p.isBestSeller).toList();
  List<ProductModel> get onSaleProducts =>
      _allProducts.where((p) => p.isOnSale).toList();
  List<ProductModel> get allProducts => List.unmodifiable(_allProducts);

  final List<TipModel> _tips = TipModel.getMockTips();
  List<TipModel> get tips => List.unmodifiable(_tips);

  // ─── Daily Tip ───────────────────────────────────────────────────────────────
  int _currentTipIndex = 0;

  TipModel get dailyTip {
    if (_tips.isEmpty) {
      return const TipModel(
        id: 'default',
        title: 'ยินดีต้อนรับสู่ FarmPro',
        content: 'ค้นหาสินค้าเกษตรคุณภาพสูงได้ที่นี่',
        icon: '🌾',
        category: 'ทั่วไป',
      );
    }
    return _tips[_currentTipIndex % _tips.length];
  }

  void nextTip() {
    _currentTipIndex = (_currentTipIndex + 1) % _tips.length;
    notifyListeners();
  }

  // ─── Search ──────────────────────────────────────────────────────────────────
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  List<ProductModel> _searchResults = [];
  List<ProductModel> get searchResults => List.unmodifiable(_searchResults);

  void updateSearchQuery(String query) {
    _searchQuery = query.trim();
    _isSearching = _searchQuery.isNotEmpty;

    if (_isSearching) {
      _performSearch();
    } else {
      _searchResults = [];
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    _searchResults = [];
    notifyListeners();
  }

  void _performSearch() {
    final q = _searchQuery.toLowerCase();
    _searchResults = _allProducts.where((product) {
      return product.name.toLowerCase().contains(q) ||
          product.description.toLowerCase().contains(q) ||
          product.tags.any((tag) => tag.toLowerCase().contains(q));
    }).toList();
  }

  // ─── Category Filter ─────────────────────────────────────────────────────────
  String? _selectedCategoryId;
  String? get selectedCategoryId => _selectedCategoryId;

  List<ProductModel> get filteredProducts {
    if (_selectedCategoryId == null) return allProducts;
    return _allProducts
        .where((p) => p.categoryId == _selectedCategoryId)
        .toList();
  }

  void selectCategory(String? categoryId) {
    _selectedCategoryId =
        (_selectedCategoryId == categoryId) ? null : categoryId;
    notifyListeners();
  }

  void clearCategoryFilter() {
    _selectedCategoryId = null;
    notifyListeners();
  }

  // ─── Loading State ───────────────────────────────────────────────────────────
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ─── Refresh / Reload ────────────────────────────────────────────────────────
  Future<void> refresh() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate a network delay — replace with real API calls later
      await Future.delayed(const Duration(milliseconds: 800));
      _currentBannerIndex = 0;
    } catch (e) {
      _errorMessage = 'ไม่สามารถโหลดข้อมูลได้ กรุณาลองใหม่อีกครั้ง';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── User Greeting ───────────────────────────────────────────────────────────
  String get greetingText {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'สวัสดีตอนเช้า';
    if (hour >= 12 && hour < 17) return 'สวัสดีตอนบ่าย';
    if (hour >= 17 && hour < 21) return 'สวัสดีตอนเย็น';
    return 'สวัสดีตอนค่ำ';
  }

  String get userName => 'คุณสมชาย'; // Replace with auth user later

  // ─── Notification Badge ──────────────────────────────────────────────────────
  int _notificationCount = 3;
  int get notificationCount => _notificationCount;

  void clearNotifications() {
    _notificationCount = 0;
    notifyListeners();
  }

  void addNotification() {
    _notificationCount++;
    notifyListeners();
  }

  // ─── Wishlist (Favourite) ────────────────────────────────────────────────────
  final Set<String> _wishlistIds = {};
  Set<String> get wishlistIds => Set.unmodifiable(_wishlistIds);

  bool isWishlisted(String productId) => _wishlistIds.contains(productId);

  void toggleWishlist(String productId) {
    if (_wishlistIds.contains(productId)) {
      _wishlistIds.remove(productId);
    } else {
      _wishlistIds.add(productId);
    }
    notifyListeners();
  }

  List<ProductModel> get wishlistProducts =>
      _allProducts.where((p) => _wishlistIds.contains(p.id)).toList();
}
