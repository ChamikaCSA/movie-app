class Actor {
  final int id;
  final String name;
  final String imageUrl;

  const Actor({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      name: json['name'],
      imageUrl: json['profile_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['profile_path']}'
          : '',
    );
  }
}
