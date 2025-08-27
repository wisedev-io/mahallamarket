import 'package:flutter/material.dart';
import 'package:mahallamarket/services/mock_data.dart';
import 'package:mahallamarket/services/mock_state.dart';
import 'verification_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  final MockItem item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final msgCtrl = TextEditingController(text: '안녕하세요. 관심 있어서 문의드려요.');

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final fav = mockState.isFavorite(item.id);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share (mock)')),
            ),
          ),
          const SizedBox(width: 4),
          PopupMenuButton<int>(
            itemBuilder: (_) => const [
              PopupMenuItem(value: 1, child: Text('Report (mock)')),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          // hero image
          AspectRatio(
            aspectRatio: 16/10,
            child: Container(
              color: Colors.black12,
              child: item.imageUrl == null
                ? const Center(child: Icon(Icons.image, size: 64, color: Colors.white70))
                : Image.network(item.imageUrl!, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(child: Icon(Icons.person)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('으르렁왈왈', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text(item.neighborhood, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text('68,2°C', style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 4),
                        const Text('Manner Meter', style: TextStyle(decoration: TextDecoration.underline)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(item.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(money(item.price), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text(
                  'Electronics & Appliances · Boosted ${timeAgo(item.postedAt)} ago',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                const Text(
                  '모의 설명 텍스트입니다. 실제 백엔드 연결 시 Firestore에서 불러옵니다.',
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Where to meet'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Map (mock)')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: [
              // Favorite
              IconButton(
                onPressed: () async {
                  final nowFav = mockState.toggleFavorite(item.id);
                  setState(() {});
                  if (nowFav) {
                    await showDialog<void>(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: const Text("Added to favorites! We'll notify you whenever the price drops."),
                        actions: [ TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Confirm')) ],
                      ),
                    );
                  }
                },
                icon: Icon(
                  mockState.isFavorite(item.id) ? Icons.favorite : Icons.favorite_border,
                  color: mockState.isFavorite(item.id) ? Colors.orange : null,
                ),
              ),
              const SizedBox(width: 8),
              // Message box
              Expanded(
                child: TextField(
                  controller: msgCtrl,
                  decoration: const InputDecoration(
                    hintText: '안녕하세요. 관심 있어서 문의드려요.',
                    filled: true,
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(24))),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () async {
                  if (!mockState.neighborhoodVerified) {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Verify'),
                        content: const Text('To chat, verify neighborhood in 공동.'),
                        actions: [
                          TextButton(onPressed: ()=>Navigator.pop(context, false), child: const Text('Cancel')),
                          FilledButton(onPressed: ()=>Navigator.pop(context, true), child: const Text('Verify')),
                        ],
                      ),
                    );
                    if (ok == true && context.mounted) {
                      await Navigator.push(context, MaterialPageRoute(builder: (_)=> const VerificationScreen()));
                      return;
                    } else {
                      return;
                    }
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sent: ${msgCtrl.text.trim()} (mock)')),
                  );
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
