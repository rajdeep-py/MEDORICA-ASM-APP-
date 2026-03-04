class AboutUs {
  final String companyName;
  final String description;
  final String directorName;
  final String directorMessage;
  final String directorPhotoUrl;
  final String phone;
  final String email;
  final String address;
  final String mapUrl;
  final String website;
  final String instagram;
  final String facebook;
  final String youtube;
  final String linkedin;

  AboutUs({
    required this.companyName,
    required this.description,
    required this.directorName,
    required this.directorMessage,
    required this.directorPhotoUrl,
    required this.phone,
    required this.email,
    required this.address,
    required this.mapUrl,
    required this.website,
    required this.instagram,
    required this.facebook,
    required this.youtube,
    required this.linkedin,
  });

  factory AboutUs.fromJson(Map<String, dynamic> json) {
    return AboutUs(
      companyName: json['companyName'] ?? '',
      description: json['description'] ?? '',
      directorName: json['directorName'] ?? '',
      directorMessage: json['directorMessage'] ?? '',
      directorPhotoUrl: json['directorPhotoUrl'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      mapUrl: json['mapUrl'] ?? '',
      website: json['website'] ?? '',
      instagram: json['instagram'] ?? '',
      facebook: json['facebook'] ?? '',
      youtube: json['youtube'] ?? '',
      linkedin: json['linkedin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'description': description,
      'directorName': directorName,
      'directorMessage': directorMessage,
      'directorPhotoUrl': directorPhotoUrl,
      'phone': phone,
      'email': email,
      'address': address,
      'mapUrl': mapUrl,
      'website': website,
      'instagram': instagram,
      'facebook': facebook,
      'youtube': youtube,
      'linkedin': linkedin,
    };
  }
}