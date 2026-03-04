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
      companyName: json['company_name'] ?? 'Medorica Pharma Pvt. Ltd.',
      description: json['company_about'] ?? '',
      directorName: json['director_name'] ?? 'Director',
      directorMessage: json['director_message'] ?? '',
      directorPhotoUrl: json['director_photo_url'] ?? 'assets/logo/logo.png',
      phone: json['phn_no'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      mapUrl: json['office_address'] ?? json['address'] ?? '',
      website: json['website'] ?? '',
      instagram: json['instagram_link'] ?? '',
      facebook: json['facebook_link'] ?? '',
      youtube: json['youtube_link'] ?? '',
      linkedin: json['linkedin_link'] ?? '',
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