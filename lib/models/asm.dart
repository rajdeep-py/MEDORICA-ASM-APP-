/// Model class for Area Sales Manager
class ASM {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? profileImage;
  final String? region;
  final String? territory;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  ASM({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.profileImage,
    this.region,
    this.territory,
    this.createdAt,
    this.lastLogin,
  });

  /// Create ASM from JSON
  factory ASM.fromJson(Map<String, dynamic> json) {
    return ASM(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String?,
      region: json['region'] as String?,
      territory: json['territory'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
    );
  }

  /// Convert ASM to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'profileImage': profileImage,
      'region': region,
      'territory': territory,
      'createdAt': createdAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  /// Create a copy of ASM with updated fields
  ASM copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? profileImage,
    String? region,
    String? territory,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return ASM(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      region: region ?? this.region,
      territory: territory ?? this.territory,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  String toString() {
    return 'ASM(id: $id, name: $name, phone: $phone, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ASM &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        email.hashCode;
  }
}
