class Team {
  final String id;
  final String name;
  final String headquarter;
  final String territory;
  final String description;
  final String? groupLink;
  final List<String> members;

  Team({
    required this.id,
    required this.name,
    required this.headquarter,
    required this.territory,
    required this.description,
    this.groupLink,
    this.members = const [],
  });

  Team copyWith({
    String? id,
    String? name,
    String? headquarter,
    String? territory,
    String? description,
    String? groupLink,
    List<String>? members,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      headquarter: headquarter ?? this.headquarter,
      territory: territory ?? this.territory,
      description: description ?? this.description,
      groupLink: groupLink ?? this.groupLink,
      members: members ?? this.members,
    );
  }
}
