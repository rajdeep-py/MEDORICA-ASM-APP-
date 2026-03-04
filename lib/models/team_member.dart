class TeamMember {
  final String id;
  final String name;
  final String phone;
  final String? altPhone;
  final String? email;
  final String? photoUrl;
  final String headquarter;
  final List<String> territories;
  final String teamId;

  TeamMember({
    required this.id,
    required this.name,
    required this.phone,
    this.altPhone,
    this.email,
    this.photoUrl,
    required this.headquarter,
    this.territories = const [],
    required this.teamId,
  });

  TeamMember copyWith({
    String? id,
    String? name,
    String? phone,
    String? altPhone,
    String? email,
    String? photoUrl,
    String? headquarter,
    List<String>? territories,
    String? teamId,
  }) {
    return TeamMember(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      altPhone: altPhone ?? this.altPhone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      headquarter: headquarter ?? this.headquarter,
      territories: territories ?? this.territories,
      teamId: teamId ?? this.teamId,
    );
  }
}
