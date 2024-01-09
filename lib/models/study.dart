class Study {
  final String name, category, description;
  final int? id;
  final int now, max;
  final bool canDelete;

  const Study({
    this.id,
    required this.name,
    required this.category,
    required this.description,
    this.now = 0,
    required this.max,
    this.canDelete = false,
  });

  factory Study.fromJson(Map<String, dynamic> json) {
    return Study(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      now: json['now'],
      max: json['max'],
      canDelete: (json['canDelete'] ?? 0) == 0 ? false : true,
    );
  }
}
