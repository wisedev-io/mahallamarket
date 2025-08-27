import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mahallamarket/env.dart';
import 'package:mahallamarket/domain/repos/items_repository.dart';
import 'package:mahallamarket/data/items_repository_mock.dart';
import 'package:mahallamarket/data/items_repository_firebase.dart';

class Repositories {
  static late ItemsRepository items;

  static Future<void> init() async {
    final useMock = Env.noBackend || kIsWeb;
    items = useMock ? ItemsRepositoryMock() : ItemsRepositoryFirebase();
  }
}
