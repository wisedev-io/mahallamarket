import 'dart:math';

class MockItem {
  final String id;
  String title;
  String neighborhood; // e.g., district / sector
  DateTime postedAt;
  double price;
  String? imageUrl;
  int likes;
  int chats;

  MockItem({
    required this.id,
    required this.title,
    required this.neighborhood,
    required this.postedAt,
    required this.price,
    this.imageUrl,
    this.likes = 0,
    this.chats = 0,
  });
}

final _now = DateTime.now();
final mockItems = <MockItem>[
  MockItem(
    id: '1',
    title: '경호원모집 (남녀무관)',
    neighborhood: '강서구 화곡동 · 알바',
    postedAt: _now.subtract(const Duration(hours: 3)),
    price: 3000000,
    imageUrl: null,
    likes: 37,
    chats: 26,
  ),
  MockItem(
    id: '2',
    title: '토끼 바니걸 코스프레',
    neighborhood: '목동',
    postedAt: _now.subtract(const Duration(days: 1)),
    price: 11500,
    imageUrl: null,
    likes: 30,
    chats: 7,
  ),
  MockItem(
    id: '3',
    title: '필요하신분 다가져가세요 600개',
    neighborhood: '화곡제1동',
    postedAt: _now.subtract(const Duration(hours: 8)),
    price: 500,
    imageUrl: null,
    likes: 4,
    chats: 1,
  ),
  MockItem(
    id: '4',
    title: '하루 일해도 38만원 가능한 꿀알바 모집',
    neighborhood: '쿠팡로지스틱스서비스 · AD',
    postedAt: _now.subtract(const Duration(hours: 5)),
    price: 380000,
    imageUrl: null,
    likes: 0,
    chats: 0,
  ),
];

String money(num v) {
  // crude KRW formatting
  final s = v.toStringAsFixed(0);
  final buf = StringBuffer('₩');
  for (int i = 0; i < s.length; i++) {
    if (i>0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

String timeAgo(DateTime dt) {
  final d = DateTime.now().difference(dt);
  if (d.inMinutes < 60) return '${d.inMinutes}m';
  if (d.inHours < 24) return '${d.inHours}h';
  return '${d.inDays}d';
}

void addMockItem({
  required String title,
  required double price,
  required String neighborhood,
}) {
  final id = DateTime.now().millisecondsSinceEpoch.toString();
  mockItems.insert(0, MockItem(
    id: id,
    title: title,
    neighborhood: neighborhood,
    postedAt: DateTime.now(),
    price: price,
    imageUrl: null,
    likes: Random().nextInt(10),
    chats: Random().nextInt(5),
  ));
}
