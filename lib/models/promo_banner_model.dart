import 'package:flutter/material.dart';

class PromoBannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String discountText;
  final String discountLabel;
  final Color backgroundColor;
  final Color gradientEndColor;
  final String badgeText;
  final String emoji;

  const PromoBannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.discountText,
    required this.discountLabel,
    required this.backgroundColor,
    required this.gradientEndColor,
    required this.badgeText,
    required this.emoji,
  });

  static List<PromoBannerModel> getMockBanners() {
    return [
      const PromoBannerModel(
        id: 'banner_001',
        title: 'โปรโมชันสมาชิก',
        subtitle: 'ลดทันที',
        discountText: '30%',
        discountLabel: 'ส่วนลด',
        backgroundColor: Color(0xFF6D4C41),
        gradientEndColor: Color(0xFF4E342E),
        badgeText: '🔥 โปรโมชันพิเศษ',
        emoji: '💧',
      ),
      const PromoBannerModel(
        id: 'banner_002',
        title: 'ปุ๋ยอินทรีย์คุณภาพสูง',
        subtitle: 'ซื้อ 2 แถม 1',
        discountText: 'BUY2\nGET1',
        discountLabel: 'ฟรี!',
        backgroundColor: Color(0xFF2E7D32),
        gradientEndColor: Color(0xFF1B5E20),
        badgeText: '🌿 สินค้าแนะนำ',
        emoji: '🌱',
      ),
      const PromoBannerModel(
        id: 'banner_003',
        title: 'สารกำจัดแมลง',
        subtitle: 'ลดราคาพิเศษ',
        discountText: '50%',
        discountLabel: 'ส่วนลด',
        backgroundColor: Color(0xFF1565C0),
        gradientEndColor: Color(0xFF0D47A1),
        badgeText: '⚡ Flash Sale',
        emoji: '🐛',
      ),
      const PromoBannerModel(
        id: 'banner_004',
        title: 'เมล็ดพันธุ์ฤดูใหม่',
        subtitle: 'พร้อมส่งทั่วประเทศ',
        discountText: '25%',
        discountLabel: 'ส่วนลด',
        backgroundColor: Color(0xFFF57F17),
        gradientEndColor: Color(0xFFE65100),
        badgeText: '🌾 ฤดูเพาะปลูก',
        emoji: '🌻',
      ),
    ];
  }
}
