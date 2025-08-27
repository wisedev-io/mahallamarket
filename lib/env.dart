class Env {
  static const bool noBackend =
      bool.fromEnvironment('NO_BACKEND', defaultValue: false);
}
