import '../services/api_url.dart';

class Doctor {
  final String id;
  final String? asmId;
  final String name;
  final String phoneNumber;
  final String email;
  final String photo;
  final String specialization;
  final String experience;
  final String qualification;
  final String description;
  final DateTime? birthday;
  final String address;
  final List<DoctorChamber> chambers;

  Doctor({
    required this.id,
    this.asmId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.photo,
    required this.specialization,
    required this.experience,
    required this.qualification,
    required this.description,
    this.birthday,
    this.address = '',
    required this.chambers,
  });

  // Copy with method for updates
  Doctor copyWith({
    String? id,
    String? asmId,
    String? name,
    String? phoneNumber,
    String? email,
    String? photo,
    String? specialization,
    String? experience,
    String? qualification,
    String? description,
    DateTime? birthday,
    String? address,
    List<DoctorChamber>? chambers,
  }) {
    return Doctor(
      id: id ?? this.id,
      asmId: asmId ?? this.asmId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      qualification: qualification ?? this.qualification,
      description: description ?? this.description,
      birthday: birthday ?? this.birthday,
      address: address ?? this.address,
      chambers: chambers ?? this.chambers,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'doctor_id': id,
    'asm_id': asmId,
    'doctor_name': name,
    'doctor_phone_no': phoneNumber,
    'doctor_email': email,
    'doctor_photo': photo,
    'doctor_specialization': specialization,
    'doctor_experience': experience,
    'doctor_qualification': qualification,
    'doctor_description': description,
    'doctor_birthday': birthday?.toIso8601String(),
    'doctor_address': address,
    'doctor_chambers': chambers.map((c) => c.toJson()).toList(),
  };

  // Create from JSON
  factory Doctor.fromJson(Map<String, dynamic> json) {
    final rawPhoto = _stringOrEmpty(json['doctor_photo'] ?? json['photo']);
    final photo = _normalizePhoto(rawPhoto);

    return Doctor(
      id: _stringOrEmpty(json['doctor_id'] ?? json['id']),
      asmId: _nullableString(json['asm_id']),
      name: _stringOrEmpty(json['doctor_name'] ?? json['name']),
      phoneNumber: _stringOrEmpty(
        json['doctor_phone_no'] ?? json['phoneNumber'],
      ),
      email: _stringOrEmpty(json['doctor_email'] ?? json['email']),
      photo: photo,
      specialization: _stringOrEmpty(
        json['doctor_specialization'] ?? json['specialization'],
      ),
      experience: _stringOrEmpty(
        json['doctor_experience'] ?? json['experience'],
      ),
      qualification: _stringOrEmpty(
        json['doctor_qualification'] ?? json['qualification'],
      ),
      description: _stringOrEmpty(
        json['doctor_description'] ?? json['description'],
      ),
      birthday: _parseDate(json['doctor_birthday']),
      address: _stringOrEmpty(json['doctor_address'] ?? json['address']),
      chambers: _parseChambers(json['doctor_chambers'] ?? json['chambers']),
    );
  }

  static String _normalizePhoto(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    final normalized = trimmed.startsWith('/') ? trimmed : '/$trimmed';
    return ApiUrl.getFullUrl(normalized);
  }

  static List<DoctorChamber> _parseChambers(dynamic data) {
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(DoctorChamber.fromJson)
        .toList();
  }

  static String _stringOrEmpty(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString();
  }

  static String? _nullableString(dynamic value) {
    if (value == null) {
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value.toString())?.toLocal();
  }
}

class DoctorChamber {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;

  DoctorChamber({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
  });

  DoctorChamber copyWith({
    String? id,
    String? name,
    String? address,
    String? phoneNumber,
  }) {
    return DoctorChamber(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toJson() => {
    'chamber_id': id,
    'chamber_name': name,
    'chamber_address': address,
    'chamber_phone_no': phoneNumber,
  };

  factory DoctorChamber.fromJson(Map<String, dynamic> json) => DoctorChamber(
    id: (json['chamber_id'] ?? json['id'] ?? '').toString(),
    name: (json['chamber_name'] ?? json['name'] ?? '').toString(),
    address: (json['chamber_address'] ?? json['address'] ?? '').toString(),
    phoneNumber: (json['chamber_phone_no'] ?? json['phoneNumber'] ?? '')
        .toString(),
  );
}
