// ─────────────────────────────────────────────
//  models/tip_model.dart
//  Agricultural Knowledge / Daily Tip model
// ─────────────────────────────────────────────

class TipModel {
  final String id;
  final String title;
  final String content;
  final String icon;
  final String category;
  final String? relatedProductId;
  final String? relatedProductName;

  const TipModel({
    required this.id,
    required this.title,
    required this.content,
    required this.icon,
    required this.category,
    this.relatedProductId,
    this.relatedProductName,
  });

  // ── Mock Data ────────────────────────────────
  static List<TipModel> getMockTips() {
    return [
      const TipModel(
        id: 'tip_001',
        title: 'ช่วงอากาศร้อน ควรใส่ปุ๋ยตอนเช้าตรู่หรือเย็น',
        content:
            'ช่วงหน้าร้อนอุณหภูมิสูง ควรใส่ปุ๋ยในช่วงเช้าตรู่ (06:00–08:00 น.) '
            'หรือช่วงเย็น (17:00–19:00 น.) เพื่อให้รากพืชดูดซึมได้อย่างมีประสิทธิภาพ '
            'และลดการสูญเสียธาตุอาหารจากการระเหย',
        icon: '💡',
        category: 'การใส่ปุ๋ย',
        relatedProductId: 'prod_003',
        relatedProductName: 'ปุ๋ยน้ำสูตรเข้มข้น',
      ),
      const TipModel(
        id: 'tip_002',
        title: 'วิธีผสมปุ๋ยอินทรีย์ให้ได้ผลสูงสุด',
        content:
            'ควรผสมปุ๋ยอินทรีย์กับดินในอัตราส่วน 1:3 (ปุ๋ย 1 ส่วน ต่อดิน 3 ส่วน) '
            'และพรวนดินให้เข้ากันก่อนปลูก จะช่วยให้จุลินทรีย์ในดินทำงานได้ดีขึ้น '
            'และพืชเจริญเติบโตได้แข็งแรง',
        icon: '🌱',
        category: 'ปุ๋ยอินทรีย์',
        relatedProductId: 'prod_001',
        relatedProductName: 'ปุ๋ยอินทรีย์ชีวภาพ AAA',
      ),
      const TipModel(
        id: 'tip_003',
        title: 'สังเกตอาการขาดธาตุอาหารจากใบพืช',
        content:
            'ใบเหลืองทั้งต้น = ขาดไนโตรเจน (N) | ใบม่วงแดง = ขาดฟอสฟอรัส (P) | '
            'ขอบใบไหม้ = ขาดโพแทสเซียม (K) สังเกตอาการแล้วเลือกปุ๋ยให้ตรงจุด '
            'จะประหยัดต้นทุนและได้ผลดีกว่า',
        icon: '🍃',
        category: 'โรคพืช',
        relatedProductId: 'prod_002',
        relatedProductName: 'ปุ๋ยเคมีสูตร 15-15-15',
      ),
      const TipModel(
        id: 'tip_004',
        title: 'กำจัดแมลงศัตรูพืชด้วยวิธีธรรมชาติ',
        content:
            'น้ำส้มควันไม้เจือจาง 1:500 ฉีดพ่นในตอนเช้าหรือเย็น ช่วยไล่แมลงได้ดี '
            'หรือใช้สะเดาสกัดที่มีสาร Azadirachtin เพื่อกำจัดแมลงโดยไม่ทำลายแมลงที่มีประโยชน์',
        icon: '🐛',
        category: 'กำจัดแมลง',
        relatedProductId: 'prod_004',
        relatedProductName: 'ยาฆ่าแมลงออร์แกนิค',
      ),
      const TipModel(
        id: 'tip_005',
        title: 'วิธีเก็บรักษาเมล็ดพันธุ์ให้อยู่นานหลายปี',
        content:
            'เก็บเมล็ดพันธุ์ในภาชนะปิดสนิท ใส่ซิลิกาเจลดูดความชื้น แล้วเก็บในที่เย็นและมืด '
            'ที่อุณหภูมิ 10–15°C ความชื้นไม่เกิน 40% จะช่วยให้เมล็ดพันธุ์งอกได้ดีนาน 2–5 ปี',
        icon: '🌾',
        category: 'เมล็ดพันธุ์',
        relatedProductId: 'prod_005',
        relatedProductName: 'เมล็ดพันธุ์ข้าวโพดหวาน',
      ),
      const TipModel(
        id: 'tip_006',
        title: 'การให้น้ำพืชอย่างถูกวิธีประหยัดน้ำ 40%',
        content:
            'ใช้ระบบน้ำหยดแทนการรดน้ำแบบทั่วไป จะประหยัดน้ำได้ถึง 40–60% '
            'โดยให้น้ำตรงรากพืช ลดการระเหยและการเจริญเติบโตของวัชพืช '
            'เหมาะกับทุกประเภทของพืชสวนและพืชไร่',
        icon: '💧',
        category: 'การให้น้ำ',
        relatedProductId: 'prod_006',
        relatedProductName: 'ปุ๋ยน้ำละลายน้ำ FK-1',
      ),
      const TipModel(
        id: 'tip_007',
        title: 'ปลูกพืชหมุนเวียนเพิ่มความอุดมสมบูรณ์ดิน',
        content:
            'ปลูกพืชตระกูลถั่วสลับกับพืชหลัก เช่น ถั่วเขียว หรือถั่วลิสง '
            'จะช่วยตรึงไนโตรเจนในดินตามธรรมชาติ ลดการใช้ปุ๋ยไนโตรเจนได้ 20–30% '
            'และช่วยปรับโครงสร้างดินให้ร่วนซุย',
        icon: '🔄',
        category: 'การเกษตรยั่งยืน',
        relatedProductId: 'prod_007',
        relatedProductName: 'เมล็ดพันธุ์ถั่วเขียว',
      ),
      const TipModel(
        id: 'tip_008',
        title: 'ทำปุ๋ยหมักจากเศษผักผลไม้ง่ายๆ ที่บ้าน',
        content:
            'นำเศษผัก ผลไม้ และใบไม้แห้งผสมกันในอัตราส่วน 1:1 รดน้ำให้ชุ่ม '
            'พลิกกลับทุก 7 วัน ภายใน 30–45 วัน จะได้ปุ๋ยหมักคุณภาพดี '
            'ประหยัดต้นทุนและช่วยลดขยะในครัวเรือน',
        icon: '♻️',
        category: 'ปุ๋ยอินทรีย์',
        relatedProductId: 'prod_008',
        relatedProductName: 'น้ำหมักชีวภาพ EM',
      ),
    ];
  }

  // ── CopyWith ─────────────────────────────────
  TipModel copyWith({
    String? id,
    String? title,
    String? content,
    String? icon,
    String? category,
    String? relatedProductId,
    String? relatedProductName,
  }) {
    return TipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      relatedProductId: relatedProductId ?? this.relatedProductId,
      relatedProductName: relatedProductName ?? this.relatedProductName,
    );
  }

  // ── Equality ─────────────────────────────────
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is TipModel && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TipModel(id: $id, title: $title, category: $category)';
}
