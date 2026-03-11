import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageEmoji;
  final String categoryId;
  final double rating;
  final int reviewCount;
  final int stock;
  final List<String> tags;
  final bool isBestSeller;
  final bool isOnSale;
  final String unit;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageEmoji,
    required this.categoryId,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stock = 0,
    this.tags = const [],
    this.isBestSeller = false,
    this.isOnSale = false,
    this.unit = 'ถุง',
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  double get discountPercent {
    if (!hasDiscount) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageEmoji,
    String? categoryId,
    double? rating,
    int? reviewCount,
    int? stock,
    List<String>? tags,
    bool? isBestSeller,
    bool? isOnSale,
    String? unit,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageEmoji: imageEmoji ?? this.imageEmoji,
      categoryId: categoryId ?? this.categoryId,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      stock: stock ?? this.stock,
      tags: tags ?? this.tags,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      isOnSale: isOnSale ?? this.isOnSale,
      unit: unit ?? this.unit,
    );
  }
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

final List<ProductModel> mockProducts = [
  const ProductModel(
    id: 'p001',
    name: 'ปุ๋ยอินทรีย์ชีวภาพ สูตร 1',
    description:
        'ปุ๋ยอินทรีย์ผสมจุลินทรีย์ที่มีประโยชน์ เพิ่มธาตุอาหารในดิน เหมาะสำหรับพืชทุกชนิด',
    price: 250,
    originalPrice: 320,
    imageEmoji: '🌱',
    categoryId: 'cat001',
    rating: 4.8,
    reviewCount: 234,
    stock: 150,
    tags: ['ออร์แกนิค', 'ปลอดภัย', 'ดินดี'],
    isBestSeller: true,
    isOnSale: true,
    unit: 'ถุง 25 กก.',
  ),
  const ProductModel(
    id: 'p002',
    name: 'ปุ๋ยเคมี สูตร 15-15-15',
    description:
        'ปุ๋ยเคมีสูตรสมดุล ไนโตรเจน ฟอสฟอรัส โพแทสเซียม เท่ากัน เหมาะสำหรับพืชไร่',
    price: 185,
    originalPrice: 220,
    imageEmoji: '🧪',
    categoryId: 'cat002',
    rating: 4.5,
    reviewCount: 189,
    stock: 200,
    tags: ['สมดุล', 'พืชไร่', 'ผลผลิตดี'],
    isBestSeller: true,
    isOnSale: true,
    unit: 'ถุง 50 กก.',
  ),
  const ProductModel(
    id: 'p003',
    name: 'ปุ๋ยน้ำสูตรเข้มข้น 20-20-20',
    description:
        'ปุ๋ยน้ำสูตรเข้มข้นสูง ละลายน้ำได้ดี เหมาะสำหรับการให้ทางใบและระบบน้ำหยด',
    price: 320,
    imageEmoji: '💧',
    categoryId: 'cat003',
    rating: 4.7,
    reviewCount: 312,
    stock: 80,
    tags: ['ทางใบ', 'น้ำหยด', 'เข้มข้น'],
    isBestSeller: true,
    isOnSale: false,
    unit: 'แกลลอน 5 ล.',
  ),
  const ProductModel(
    id: 'p004',
    name: 'ยาฆ่าแมลงออร์แกนิค',
    description:
        'สารกำจัดแมลงจากธรรมชาติ สกัดจากพืช ปลอดภัยต่อผู้ใช้และสิ่งแวดล้อม',
    price: 180,
    originalPrice: 250,
    imageEmoji: '🐛',
    categoryId: 'cat004',
    rating: 4.6,
    reviewCount: 145,
    stock: 60,
    tags: ['ออร์แกนิค', 'ปลอดภัย', 'สิ่งแวดล้อม'],
    isBestSeller: false,
    isOnSale: true,
    unit: 'ขวด 1 ล.',
  ),
  const ProductModel(
    id: 'p005',
    name: 'เมล็ดพันธุ์ข้าวโพดหวาน',
    description:
        'เมล็ดพันธุ์ข้าวโพดหวานคุณภาพสูง อัตราการงอกสูง ให้ผลผลิตมาก ทนต่อโรค',
    price: 120,
    imageEmoji: '🌽',
    categoryId: 'cat005',
    rating: 4.9,
    reviewCount: 421,
    stock: 500,
    tags: ['หวาน', 'ผลผลิตสูง', 'ทนโรค'],
    isBestSeller: true,
    isOnSale: false,
    unit: 'ซอง 500 ก.',
  ),
  const ProductModel(
    id: 'p006',
    name: 'ฮิวมิค แอซิด เข้มข้น',
    description:
        'ฮิวมิค แอซิด ช่วยปรับปรุงโครงสร้างดิน เพิ่มการดูดซึมธาตุอาหาร รากแข็งแรง',
    price: 450,
    originalPrice: 550,
    imageEmoji: '🌾',
    categoryId: 'cat001',
    rating: 4.4,
    reviewCount: 98,
    stock: 45,
    tags: ['ดินดี', 'รากแข็งแรง', 'พรีเมียม'],
    isBestSeller: false,
    isOnSale: true,
    unit: 'ถุง 1 กก.',
  ),
  const ProductModel(
    id: 'p007',
    name: 'ปุ๋ยน้ำเร่งดอก-ผล สูตร 6-30-30',
    description:
        'ปุ๋ยน้ำสูตรเร่งดอกและผล ฟอสฟอรัสและโพแทสเซียมสูง ช่วยให้ดอกติดดีและผลใหญ่',
    price: 280,
    imageEmoji: '🌸',
    categoryId: 'cat003',
    rating: 4.8,
    reviewCount: 267,
    stock: 120,
    tags: ['เร่งดอก', 'ผลใหญ่', 'คุณภาพ'],
    isBestSeller: true,
    isOnSale: false,
    unit: 'แกลลอน 5 ล.',
  ),
  const ProductModel(
    id: 'p008',
    name: 'เมล็ดพันธุ์มะเขือเทศ Cherry',
    description:
        'มะเขือเทศเชอร์รีพันธุ์ดี ผลดก รสหวาน เหมาะสำหรับปลูกทั้งในดินและไฮโดรโปนิกส์',
    price: 95,
    imageEmoji: '🍅',
    categoryId: 'cat005',
    rating: 4.7,
    reviewCount: 356,
    stock: 300,
    tags: ['เชอร์รี่', 'ไฮโดร', 'ผลดก'],
    isBestSeller: false,
    isOnSale: false,
    unit: 'ซอง 100 เมล็ด',
  ),
];

// ─── Category Color Helper ────────────────────────────────────────────────────

Color getProductCategoryColor(String categoryId) {
  switch (categoryId) {
    case 'cat001':
      return const Color(0xFFE8F5E9);
    case 'cat002':
      return const Color(0xFFFFFDE7);
    case 'cat003':
      return const Color(0xFFE3F2FD);
    case 'cat004':
      return const Color(0xFFFCE4EC);
    case 'cat005':
      return const Color(0xFFF3E5F5);
    default:
      return const Color(0xFFF5F5F5);
  }
}
