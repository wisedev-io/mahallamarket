/// Build-time flags.
/// Use: --dart-define=NO_BACKEND=true  (web/dev)
class Env {
  static const bool noBackend =
      bool.fromEnvironment('NO_BACKEND', defaultValue: false);
}
