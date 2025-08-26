import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repos/chat_repo.dart';
import '../../models/message.dart';

class ApiChatRepo implements ChatRepo {
  @override
  String conversationIdFor(String a, String b) {
    final ids = [a, b]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  @override
  Future<void> ensureConversation(String uid1, String uid2) async {
    throw UnimplementedError('Implement API call later');
  }

  @override
  Future<void> sendMessage({required String senderId, required String receiverId, required String text}) async {
    throw UnimplementedError('Implement API call later');
  }

  @override
  Stream<List<Message>> streamMessages(String uid1, String uid2, {int limit = 50}) {
    return const Stream.empty();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamConversations(String uid) {
    return const Stream.empty();
  }
}
