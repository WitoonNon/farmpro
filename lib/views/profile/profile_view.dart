// ─────────────────────────────────────────────────────────────────────────────
//  views/profile/profile_view.dart
//  User profile screen with account info, settings, and app preferences
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Collapsible App Bar with avatar ──────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.headerMid,
            flexibleSpace: FlexibleSpaceBar(
              background: _ProfileHeroSection(),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),

          // ── Body content ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Membership badge
                  _MembershipCard(),

                  const SizedBox(height: 20),

                  // Account settings group
                  _SettingsGroup(
                    title: 'บัญชีของฉัน',
                    items: [
                      _SettingsItem(
                        icon: Icons.person_outline_rounded,
                        iconColor: AppColors.primary,
                        iconBg: AppColors.primaryContainer,
                        label: 'ข้อมูลส่วนตัว',
                        subtitle: 'ชื่อ, เบอร์โทร, ที่อยู่',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.location_on_outlined,
                        iconColor: const Color(0xFF1565C0),
                        iconBg: const Color(0xFFE3F2FD),
                        label: 'ที่อยู่จัดส่ง',
                        subtitle: 'จัดการที่อยู่จัดส่งของคุณ',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.account_balance_wallet_outlined,
                        iconColor: const Color(0xFF6A1B9A),
                        iconBg: const Color(0xFFF3E5F5),
                        label: 'วิธีการชำระเงิน',
                        subtitle: 'บัตรเครดิต, พร้อมเพย์, เงินสด',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Order settings group
                  _SettingsGroup(
                    title: 'คำสั่งซื้อ',
                    items: [
                      _SettingsItem(
                        icon: Icons.receipt_long_outlined,
                        iconColor: AppColors.shippingOrange,
                        iconBg: const Color(0xFFFFF3E0),
                        label: 'ประวัติการสั่งซื้อ',
                        subtitle: 'ดูคำสั่งซื้อทั้งหมด',
                        onTap: () {},
                        badge: '2',
                      ),
                      _SettingsItem(
                        icon: Icons.local_shipping_outlined,
                        iconColor: const Color(0xFF00838F),
                        iconBg: const Color(0xFFE0F7FA),
                        label: 'ติดตามพัสดุ',
                        subtitle: 'ดูสถานะการจัดส่ง',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.replay_rounded,
                        iconColor: AppColors.secondary,
                        iconBg: AppColors.secondaryContainer,
                        label: 'คืนสินค้า / คืนเงิน',
                        subtitle: 'ยื่นคำขอคืนสินค้า',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Farm / Knowledge group
                  _SettingsGroup(
                    title: 'ฟาร์มของฉัน',
                    items: [
                      _SettingsItem(
                        icon: Icons.agriculture_outlined,
                        iconColor: AppColors.primary,
                        iconBg: AppColors.primaryContainer,
                        label: 'ข้อมูลฟาร์ม',
                        subtitle: 'ประเภทพืช, ขนาดพื้นที่, ภูมิภาค',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.menu_book_outlined,
                        iconColor: const Color(0xFF33691E),
                        iconBg: const Color(0xFFDCEDC8),
                        label: 'บันทึกเคล็ดลับที่บันทึกไว้',
                        subtitle: 'คลังความรู้การเกษตรของคุณ',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.favorite_outline_rounded,
                        iconColor: Colors.redAccent,
                        iconBg: const Color(0xFFFFEBEE),
                        label: 'สินค้าที่ชอบ',
                        subtitle: 'รายการสินค้า Wishlist ของคุณ',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // App settings group
                  _SettingsGroup(
                    title: 'การตั้งค่าแอป',
                    items: [
                      _SettingsItem(
                        icon: Icons.notifications_outlined,
                        iconColor: const Color(0xFFF57F17),
                        iconBg: const Color(0xFFFFF9C4),
                        label: 'การแจ้งเตือน',
                        subtitle: 'โปรโมชัน, สินค้าใหม่, สถานะคำสั่งซื้อ',
                        onTap: () {},
                        hasToggle: true,
                        toggleValue: true,
                      ),
                      _SettingsItem(
                        icon: Icons.language_rounded,
                        iconColor: AppColors.info,
                        iconBg: const Color(0xFFE3F2FD),
                        label: 'ภาษา',
                        subtitle: 'ภาษาไทย',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.dark_mode_outlined,
                        iconColor: const Color(0xFF37474F),
                        iconBg: const Color(0xFFECEFF1),
                        label: 'โหมดมืด',
                        subtitle: 'ใช้ธีมสีเข้ม',
                        onTap: () {},
                        hasToggle: true,
                        toggleValue: false,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Help & Support group
                  _SettingsGroup(
                    title: 'ช่วยเหลือ & ติดต่อ',
                    items: [
                      _SettingsItem(
                        icon: Icons.headset_mic_outlined,
                        iconColor: AppColors.primary,
                        iconBg: AppColors.primaryContainer,
                        label: 'ติดต่อฝ่ายบริการลูกค้า',
                        subtitle: 'โทร / แชท / อีเมล',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.quiz_outlined,
                        iconColor: AppColors.secondary,
                        iconBg: AppColors.secondaryContainer,
                        label: 'คำถามที่พบบ่อย (FAQ)',
                        subtitle: 'หาคำตอบได้ที่นี่',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.policy_outlined,
                        iconColor: AppColors.textSecondary,
                        iconBg: const Color(0xFFF5F5F5),
                        label: 'นโยบายความเป็นส่วนตัว',
                        subtitle: 'เงื่อนไขการใช้งาน',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // App version chip
                  Center(
                    child: Text(
                      'FarmPro v1.0.0 • ©2025 FarmPro Thailand',
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Log out button
                  _LogoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Profile Hero Section ─────────────────────────────────────────────────────

class _ProfileHeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.headerDark, AppColors.headerMid, AppColors.primary],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF81C784), AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('👨‍🌾', style: TextStyle(fontSize: 36)),
                    ),
                  ),
                  // Edit icon
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'คุณสมชาย ใจดี',
                      style: AppTextStyles.usernameText,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_rounded,
                          size: 12,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '081-234-5678',
                          style: AppTextStyles.greetingText,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'จ.เชียงใหม่',
                          style: AppTextStyles.greetingText,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Stats row
                    Row(
                      children: [
                        _statChip(label: '12', sub: 'คำสั่งซื้อ'),
                        const SizedBox(width: 8),
                        _statChip(label: '5', sub: 'รีวิว'),
                        const SizedBox(width: 8),
                        _statChip(label: '8', sub: 'Wishlist'),
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

  Widget _statChip({required String label, required String sub}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.sarabun(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            sub,
            style: GoogleFonts.sarabun(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Membership Card ──────────────────────────────────────────────────────────

class _MembershipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF9A825), Color(0xFFFF8F00)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF9A825).withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('👑', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สมาชิก Gold',
                  style: GoogleFonts.sarabun(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'ใช้ส่วนลดได้ 30% ทุกคำสั่งซื้อ',
                  style: GoogleFonts.sarabun(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'อัปเกรด',
              style: GoogleFonts.sarabun(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFF8F00),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Settings Group ───────────────────────────────────────────────────────────

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group title
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(title, style: AppTextStyles.headlineSmall),
        ),

        // Settings card
        Container(
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
            children: List.generate(items.length, (index) {
              return Column(
                children: [
                  items[index],
                  if (index < items.length - 1)
                    const Divider(
                      height: 1,
                      indent: 60,
                      endIndent: 0,
                      color: AppColors.divider,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ─── Settings Item ────────────────────────────────────────────────────────────

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final String? badge;
  final bool hasToggle;
  final bool toggleValue;

  const _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    this.subtitle,
    required this.onTap,
    this.badge,
    this.hasToggle = false,
    this.toggleValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: iconColor.withOpacity(0.06),
        highlightColor: iconColor.withOpacity(0.03),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              // Icon bubble
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),

              const SizedBox(width: 14),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.titleMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: AppTextStyles.bodySmall),
                    ],
                  ],
                ),
              ),

              // Right accessory
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge!,
                    style: GoogleFonts.sarabun(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                )
              else if (hasToggle)
                Transform.scale(
                  scale: 0.85,
                  child: Switch(
                    value: toggleValue,
                    onChanged: (_) => onTap(),
                    activeColor: AppColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Logout Button ────────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.error, width: 1.5),
          foregroundColor: AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: Text(
          'ออกจากระบบ',
          style: AppTextStyles.buttonMedium.copyWith(
            color: AppColors.error,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'ออกจากระบบ',
          style: AppTextStyles.headlineSmall,
        ),
        content: Text(
          'คุณต้องการออกจากระบบใช่ไหม?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'ยกเลิก',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: implement actual logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              minimumSize: const Size(90, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'ออกจากระบบ',
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
