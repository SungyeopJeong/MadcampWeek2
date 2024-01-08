class StudyModel {
  final String name, category, description, id, max;

  StudyModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        category = json['category'],
        description = json['description'],
        max = json['max'];
}
