class Study {
  final String name, category, description;
  final int? id;
  final int now, max;

  const Study({
    this.id,
    required this.name,
    required this.category,
    required this.description,
    this.now = 0,
    required this.max,
  });

  factory Study.fromJson(Map<String, dynamic> json) {
    return Study(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      max: json['max'],
    );
  }
}
