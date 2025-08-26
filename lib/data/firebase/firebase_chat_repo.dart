import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repos/chat_repo.dart';
import '../../models/message.dart';

class FirebaseChatRepo implements ChatRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  String conversationIdFor(String a, String b) {
    final ids = [a, b]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  @override
  Future<void> ensureConversation(String uid1, String uid2) async {
    final cid = conversationIdFor(uid1, uid2);
    await _db.collection('conversations').doc(cid).set({
      'participants': [uid1, uid2],
      'lastMessage': null,
      'lastTs': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    final cid = conversationIdFor(senderId, receiverId);
    final convoRef = _db.collection('conversations').doc(cid);
    final msgRef = convoRef.collection('messages').doc();
    await _db.runTransaction((tx) async {
      tx.set(msgRef, {
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'ts': FieldValue.serverTimestamp(),
      });
      tx.set(convoRef, {
        'lastMessage': text,
        'lastTs': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  @override
  Stream<List<Message>> streamMessages(String uid1, String uid2, {int limit = 50}) {
    final cid = conversationIdFor(uid1, uid2);
    return _db
        .collection('conversations').doc(cid)
        .collection('messages')
        .orderBy('ts', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => Message.fromDoc(d)).toList());
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamConversations(String uid) {
    return _db
        .collection('conversations')
        .where('participants', arrayContains: uid)
        .orderBy('lastTs', descending: true)
        .snapshots();
  }
}
