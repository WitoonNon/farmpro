import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String emoji;
  final Color backgroundColor;
  final Color iconColor;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.backgroundColor,
    required this.iconColor,
  });
}

class CategoryData {
  CategoryData._();

  static final List<CategoryModel> categories = [
    const CategoryModel(
      id: 'organic',
      name: 'ปุ๋ยอินทรีย์',
      emoji: '🌿',
      backgroundColor: Color(0xFFE8F5E9),
      iconColor: Color(0xFF2E7D32),
    ),
    const CategoryModel(
      id: 'chemical',
      name: 'ปุ๋ยเคมี',
      emoji: '🧪',
      backgroundColor: Color(0xFFFFFDE7),
      iconColor: Color(0xFFF9A825),
    ),
    const CategoryModel(
      id: 'liquid',
      name: 'ปุ๋ยน้ำ',
      emoji: '💧',
      backgroundColor: Color(0xFFE3F2FD),
      iconColor: Color(0xFF1976D2),
    ),
    const CategoryModel(
      id: 'pesticide',
      name: 'กำจัดแมลง',
      emoji: '🐛',
      backgroundColor: Color(0xFFFCE4EC),
      iconColor: Color(0xFFC62828),
    ),
    const CategoryModel(
      id: 'seeds',
      name: 'เมล็ดพันธุ์',
      emoji: '🌱',
      backgroundColor: Color(0xFFF3E5F5),
      iconColor: Color(0xFF7B1FA2),
    ),
    const CategoryModel(
      id: 'tools',
      name: 'อุปกรณ์',
      emoji: '🔧',
      backgroundColor: Color(0xFFE0F7FA),
      iconColor: Color(0xFF00838F),
    ),
    const CategoryModel(
      id: 'soil',
      name: 'ดินปลูก',
      emoji: '🪴',
      backgroundColor: Color(0xFFEFEBE9),
      iconColor: Color(0xFF5D4037),
    ),
    const CategoryModel(
      id: 'irrigation',
      name: 'ระบบน้ำ',
      emoji: '🚿',
      backgroundColor: Color(0xFFE8EAF6),
      iconColor: Color(0xFF3949AB),
    ),
  ];
}
