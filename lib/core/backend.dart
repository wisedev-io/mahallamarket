enum DataBackend { firebase, api }
class BackendConfig {
  static const DataBackend current = DataBackend.firebase; // flip to api later
}
