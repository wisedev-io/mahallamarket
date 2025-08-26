import '../core/backend.dart';
import '../domain/repos/items_repo.dart';
import '../domain/repos/chat_repo.dart';
import '../domain/repos/auth_repo.dart';
import 'firebase/firebase_items_repo.dart';
import 'firebase/firebase_chat_repo.dart';
import 'firebase/firebase_auth_repo.dart';
import 'api/api_items_repo.dart';
import 'api/api_chat_repo.dart';
import 'api/api_auth_repo.dart';

class Repos {
  static final ItemsRepo items = switch (BackendConfig.current) {
    DataBackend.firebase => FirebaseItemsRepo(),
    DataBackend.api => ApiItemsRepo(),
  };

  static final ChatRepo chat = switch (BackendConfig.current) {
    DataBackend.firebase => FirebaseChatRepo(),
    DataBackend.api => ApiChatRepo(),
  };

  static final AuthRepo auth = switch (BackendConfig.current) {
    DataBackend.firebase => FirebaseAuthRepo(),
    DataBackend.api => ApiAuthRepo(),
  };
}
