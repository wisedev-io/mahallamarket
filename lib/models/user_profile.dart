class UserProfile {
  final String uid;
  final String? phone;
  final String? displayName;
  final String? photoUrl;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> fcmTokens;

  UserProfile({
    required this.uid,
    this.phone,
    this.displayName,
    this.photoUrl,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
    this.fcmTokens = const [],
  });

  factory UserProfile.fromMap(Map<String, dynamic> map, String uid) {
    DateTime _toDt(dynamic v) {
      if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
      try {
        final toDate = v.toDate;
        if (toDate != null) return toDate();
      } catch (_) {}
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    return UserProfile(
      uid: uid,
      phone: map['phone'] as String?,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      createdAt: _toDt(map['createdAt']),
      updatedAt: _toDt(map['updatedAt']),
      fcmTokens: (map['fcmTokens'] as List?)?.cast<String>() ?? const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'fcmTokens': fcmTokens,
    };
  }
}
