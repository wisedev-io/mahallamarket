import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/message.dart';

abstract class ChatRepo {
  String conversationIdFor(String a, String b);

  Future<void> ensureConversation(String uid1, String uid2);

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  });

  Stream<List<Message>> streamMessages(String uid1, String uid2, {int limit});

  Stream<QuerySnapshot<Map<String, dynamic>>> streamConversations(String uid);
}
